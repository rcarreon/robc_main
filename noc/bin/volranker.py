#!/usr/bin/env python

import sys
import subprocess
import re
import json

# Command paths
cmd = {
    "rnetapp": "/usr/bin/rnetapp",
    "host": "/usr/bin/host",
    "psh": "/opt/xcat/bin/psh"
}

def get_volumes(filer="netapp1_nfs"):
    lines = []
    for line in sys.stdin:
        lines += line.split("\n")[:-1];

    volumes = []
    for line in lines:
        volume, _, aggregate, capacity, _, _, _ = re.split(r"\s+", line)
        volumes += [{
            "volume": volume,
            "filer": filer,
            "aggregate": aggregate,
            "capacity": capacity
        }]

    return volumes

def get_exports(volume, filer="netapp1_nfs"):
    p = subprocess.Popen([cmd["rnetapp"], filer, "exports", "list", volume],
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    exports = [i[1:] for i in stdout.split("\n")[1:-1]]

    return exports

def host(export):
    p = subprocess.Popen([cmd["host"], export],
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    host_name = ""
    if re.match(r"(?:\d+\.?){4}", stdout):
        m = re.search(r"^.+\s(.+)\.$", stdout)
        host_name = m.group(1)
    else:
        host_name = export

    return host_name, int(not p.returncode)

def mounted(volume, host):
    p = subprocess.Popen([cmd["psh"], host, "mount -l"],
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    return int(bool(re.match(r".+/vol/" + volume + r"\b", stdout, re.DOTALL)))

def fstabed(volume, host):
    p = subprocess.Popen([cmd["psh"], host, "cat /etc/fstab"],
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    return int(bool(re.match(r".+/vol/" + volume + r"\b", stdout, re.DOTALL)))

if __name__ == "__main__":
    volumes = get_volumes()

    for i in xrange(len(volumes)):
        print >> sys.stderr, i, " ", volumes[i]["volume"]

        volumes[i]["exports"] = {}
        volumes[i]["ranking"] = 0
        for export in get_exports(volumes[i]["volume"]):
            volumes[i]["exports"][export] = {
                "metrics": {}
            }

            if re.match(r".+/\d+$", export):
                volumes[i]["exports"][export]["metrics"]["subnet"] = 3
            else:
                host_name, resolves = host(export)
                volumes[i]["exports"][export]["host"] = host_name
                volumes[i]["exports"][export]["metrics"]["resolves"] = resolves

                if resolves:
                    volumes[i]["exports"][export]["metrics"]["mounted"] = mounted(volumes[i]["volume"], host_name)
                    volumes[i]["exports"][export]["metrics"]["fstabed"] = fstabed(volumes[i]["volume"], host_name)
                else:
                    volumes[i]["exports"][export]["metrics"]["mounted"] = 0
                    volumes[i]["exports"][export]["metrics"]["fstabed"] = 0

            volumes[i]["exports"][export]["ranking"] = sum(volumes[i]["exports"][export]["metrics"].values())

            volumes[i]["ranking"] += volumes[i]["exports"][export]["ranking"]

    volumes = sorted(volumes, key=lambda volume: volume["ranking"])

    print(json.dumps(volumes, sort_keys=True, indent=4, separators=(',', ': ')))
