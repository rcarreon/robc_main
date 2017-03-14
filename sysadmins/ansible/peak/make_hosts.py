from sys import stdin

for line in stdin.readlines():
    (host, ip) = line.split()
    hosts_line = host[:-1] + " ansible_ssh_host=" + ip
    print(hosts_line)
