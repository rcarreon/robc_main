import sys, os, string, threading
import paramiko

#cmd = "grep -h 'king' /opt/data/horror_20100810*"
cmd = "hostname"
outlock = threading.Lock()

def workon(host):

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, username='rcarreon')
    stdin, stdout, stderr = ssh.exec_command(cmd)
    stdin.write('xy\n')
    stdin.flush()

    with outlock:
        print stdout.readlines()

def main():
    hosts = ['noc.gnmedia.net', 'noc.peak.evolve' ] # etc
    threads = []
    for h in hosts:
        t = threading.Thread(target=workon, args=(h,))
        t.start()
        threads.append(t)
    for t in threads:
        t.join()

main()
