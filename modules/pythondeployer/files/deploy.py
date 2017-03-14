#!/usr/bin/env python2

import cookielib
import json
import urllib
import urllib2
import sys
import select
import time
import os

import paramiko
import argparse
import xcat.xcat
import MySQLdb
import re


from binascii import hexlify


def sshagentauth(transport, username):
    agent = paramiko.Agent()
    agent_keys = agent.get_keys()
    if len(agent_keys) == 0:
        return
    for key in agent_keys:
        print 'Trying ssh-agent key %s' % hexlify(key.get_fingerprint()),
        try:
            transport.auth_publickey(username, key)
            print '... success!'
            return
        except paramiko.SSHException:
            print '... nope.'

def postDeployLog(repo, deployer, vertical, environment, hashish):
    # (repo, deployer, ts, vertical, environment, hashish)
    db = MySQLdb.connect(host='app1v-deploy.sbv.prd.lax.gnmedia.net',
                        user='sbvdeploy',
                        passwd='83jd78g2jd8912',
                        db='deploylog')
    ts = str(int(time.time()))
    cur = db.cursor()
    query = "INSERT INTO deploys (repo, deployer, timestamp, vertical,\
            environment, hashish) VALUES (%s, %s, %s, %s, %s, %s)"
    cur.execute(query, (repo, deployer, ts, vertical, environment, hashish))
    db.commit()

def getDeployByTreeish(repo, vertical, hashish):
    db = MySQLdb.connect(host='app1v-deploy.sbv.prd.lax.gnmedia.net',
                        user='sbvdeploy',
                        passwd='83jd78g2jd8912',
                        db='deploylog')
    cur = db.cursor()
    query = "SELECT repo, deployer, timestamp, vertical, environment, hashish\
            FROM deploys WHERE hashish=%s AND repo=%s AND vertical=%s"
    cur.execute(query, (hashish, repo, vertical))
    result = []
    for row in cur.fetchall():
        result.append(row)
    return result

deployagentlocation = "/usr/local/bin"


parser = argparse.ArgumentParser(description='Script takes two parameters; reponame and urlpath')
parser.add_argument('-r', '--repo', action='store', required=True, dest='repo', help='Name of the repo to deploy')
parser.add_argument('-u', '--url', action='store', required=True, dest='pkgurl', help='URL of the pkgfile')
parser.add_argument('-e', '--env', action='store', required=True, dest='env', help='Environment to deploy to')
parser.add_argument('-f', '--force', action='store_true', dest='forceDeploy', required=False, help='force deploy to not check previous deploys')
args = parser.parse_args()

reponame = args.repo
pkgurl = args.pkgurl
env = args.env
forceDeploy = args.forceDeploy

hashish = pkgurl.split('/')[-1].replace('.tar', '')
environments = ['dev', 'stg', 'prd']


'''
# hardcode the command line vars for now
reponame = 'sbv-cms'
pkgurl = 'http://aarwine.gnmedia.net/deploys/sbv-cms/48bcbdbee6042224e4a62858d1b5c05afd17d318.tar'
env = 'stg'
'''

fh = open('/etc/pythondeployer/deploy_config', 'r')
settingsDict = json.load(fh)
fh.close()



if reponame not in settingsDict:
    raise Exception("missing repo from deploy_config")
if 'deploysymlink' not in settingsDict[reponame]:
    raise Exception("missing deploysymlink from deploy_config")
if 'deployto' not in settingsDict[reponame]:
    raise Exception("missing deployto noderange from deploy_config")

goDeploy = False
# if environment is not first env or forceDeploy is enabled
if environments.index(env) == 0 or forceDeploy:
    goDeploy = True
else:
    # we're not deploying to dev, check is needed.
    checkenv = environments[environments.index(env)-1]
    deploylog = getDeployByTreeish(reponame, 'sbv', hashish)
    for deploy in deploylog:
        if deploy[4] == checkenv:
            goDeploy = True


if not goDeploy:
    print "treeish ( %s ) denied to deploy to %s because is has not been deployed to %s" % (hashish, env, checkenv)
    print "use -f to force"
    sys.exit(1)


#xcat = xcat.xcat.xcat()

#deploytoHosts = xcat.nodels(settingsDict[reponame]['deployto'].replace('%s', env))

deploytoHosts = []
#repotmp = reponame.split("sbv-")[1]


if reponame == 'sbv-cms':
    for line in open('/opt/sbv/gnmedia.net.hosts'):
        if re.search('^app[0-9]v-cms.sbv.%s.lax.gnmedia.net' % env, line):
            line = line.split("IN")[0]
            line = line.rstrip()
            line = line.rstrip(".")
            deploytoHosts.append(line)
elif reponame == 'sbv-media':
    for line in open('/opt/sbv/gnmedia.net.hosts'):
        if re.search('^app[0-9]v-media.sbv.%s.lax.gnmedia.net' % env, line):
            line = line.split("IN")[0]
            line = line.rstrip()
            line = line.rstrip(".")
            deploytoHosts.append(line)
elif reponame == 'sbv-mediaplayer':
    for line in open('/opt/sbv/gnmedia.net.hosts'):
        if re.search('^app[0-9]v-media.sbv.%s.lax.gnmedia.net' % env, line):
            line = line.split("IN")[0]
            line = line.rstrip()
            line = line.rstrip(".")
            deploytoHosts.append(line)
elif reponame == 'sbv-stats':
    for line in open('/opt/sbv/gnmedia.net.hosts'):
        if re.search('^app[0-9]v-stats.sbv.%s.lax.gnmedia.net' % env, line):
            line = line.split("IN")[0]
            line = line.rstrip()
            line = line.rstrip(".")
            deploytoHosts.append(line)
elif reponame == 'sbv-yourls':
    for line in open('/opt/sbv/gnmedia.net.hosts'):
        if re.search('^app[0-9]v-yourls.sbv.%s.lax.gnmedia.net' % env, line):
            line = line.split("IN")[0]
            line = line.rstrip()
            line = line.rstrip(".")
            deploytoHosts.append(line) 
elif reponame == 'sbv-js':
    for line in open('/opt/sbv/gnmedia.net.hosts'):
        if re.search('^app[0-9]v-media.sbv.%s.lax.gnmedia.net' % env, line):
            line = line.split("IN")[0]
            line = line.rstrip()
            line = line.rstrip(".")
            deploytoHosts.append(line)


print "Reponame: ", reponame
print "Env: ", env
#print "settingsDict: ", settingsDict

postscriptHosts = deploytoHosts
if 'postscripthosts' in settingsDict[reponame]:
    postscriptHosts = settingsDict['postscripthosts']

if settingsDict[reponame]['shareddeploy']:
    # if shareddeploy is true, grab the lowest numbered app server
    # xcat.nodels returns a sorted list so we know that's the first entry
    deploytoHosts = [deploytoHosts[0]]

print settingsDict[reponame]
print "### Deploy Summary ###"
print "deploying pkg: %s" % pkgurl
print "symlink loc: %s" % settingsDict[reponame]['deploysymlink']
print "deploy to hosts:"
for entry in deploytoHosts:
    print "\t%s" % entry
print "postscript hosts:"
for entry in postscriptHosts:
    print "\t%s" % entry


# GO!
rsa_key = paramiko.RSAKey.from_private_key_file('/home/deploy/.ssh/id_rsa')

# A couple situations we need to support here.
# Do we need to do a full ./deploy-agent.py on on boxes?
# Or, are we doing a full run on app1v, and ./deploy-agent.py --only-postscripts on the rest
print ""
print "Starting deploy."

paramiko.util.log_to_file('deploy.log')

for host in deploytoHosts:
    print "deploying to: %s" % host
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.load_host_keys('/etc/pythondeployer/host_keys')
    client.connect(host, username='deploy', pkey=rsa_key)
    transport = client.get_transport()
    channel = transport.open_session()
    remotecmd = "%s/deploy-agent.py -s %s -u %s" % (deployagentlocation, settingsDict[reponame]['deploysymlink'], pkgurl)
    channel.exec_command(remotecmd)
    while channel.recv_ready:
        data = channel.recv(1024)
        if len(data) > 0:
            print data,
        else:
            break
    if channel.recv_exit_status() == 1:
        print "Errors received on remote end:"
        while channel.recv_stderr_ready:
            data = channel.recv_stderr(1024)
            if len(data) > 0:
                print data
            else:
                break
    else:
        # no errors during deploy
        postscriptHosts.remove(host)

print ""
print "Starting postscripts"
for host in postscriptHosts:
    print "running postscripts on: %s" % host
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.load_host_keys('/etc/pythondeployer/host_keys')
    client.connect(host, username='deploy', pkey=rsa_key)
    transport = client.get_transport()
    channel = transport.open_session()
    remotecmd = "%s/deploy-agent.py -s %s -u %s --only-postscripts" % (deployagentlocation, settingsDict[reponame]['deploysymlink'], pkgurl)
    channel.exec_command(remotecmd)
    while channel.recv_ready:
        data = channel.recv(1024)
        if len(data) > 0:
            print data,
        else:
            break
    if channel.recv_exit_status() == 1:
        print "Errors recevied on remote end during postscripts"
        while channel.recv_stderr_ready:
            data = channel.recv_stderr(1024)
            if len(data) > 0:
                print data
            else:
                break

postDeployLog(reponame, os.getenv("SUDO_USER"), 'sbv', env, hashish)
