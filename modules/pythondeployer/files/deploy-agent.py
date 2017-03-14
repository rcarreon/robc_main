#!/usr/bin/env python2

import os
import urllib2
import tarfile
import shutil
import socket
import argparse
import subprocess
import sys

# Sample usage: python deploy.py -s "/app/shared/docroots/cms.springboardplatform.com/current" -u "http://aarwine.gnmedia.net/deploys/arcanist/d7033ddcaeb307cba6a672b9f519d3ed3dc2703e.tar"

parser = argparse.ArgumentParser(description='Script takes symlink path, and pkg url')
parser.add_argument('-s', '--symlink', action='store', required=True, dest='symlink', help='Location of the docroot symlink')
parser.add_argument('-u', '--url', action='store', required=True, dest='pkgurl', help='URL of the pkgfile')
parser.add_argument('--only-postscripts', action='store_true', required=False, dest='onlypostscripts', help='Run post scripts only')
args = parser.parse_args()

def incrementLastPiece(tag):
    # input : 'deploy-unknown-length-of-hyphen-delimited-crap-123'
    # output: 'deploy-unknown-length-of-hyphen-delimited-crap-124'
    rsplit = tag.rsplit('-', 1)
    if rsplit[1].endswith('/'):
        rsplit[1] = rsplit[1][:-1]
    rsplit[1] = str(int(rsplit[1]) + 1)
    return '-'.join(rsplit)

def downloadBuild(url, file_name):
    u = urllib2.urlopen(url)
    f = open(file_name, 'wb')
    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])
    print "Downloading: %s Bytes: %s" % (file_name, file_size)
    file_size_dl = 0
    block_sz = 8192
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break
        file_size_dl += len(buffer)
        f.write(buffer)
        status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
        status = status + chr(8)*(len(status)+1)
        print status,
    print ""
    f.close()

def untar(tarball, tarpath):
    if not os.path.exists(tarpath):
        print "tarpath didn't exist, creating %s" % tarpath 
        os.mkdir(tarpath)
    tar = tarfile.open(tarball)
    tar.extractall(path=tarpath)
    tar.close()

# TODO Seems like post scripts should be 'pluggable'

def postMoveScripts(downloadfrom, docroot):
    env = socket.gethostname().split('.')[2]
    handleConfigs(newpath, env, downloadfrom)

def postDeployScripts():
    # restart apache
    apacherestartresults = restartApache()
    if len(apacherestartresults[1]) != 0:
        print 'ERROR restarting apache:'
        for entry in apacherestartresults[1]:
            print entry
    for entry in apacherestartresults[0]:
        print entry

def handleConfigs(docroot, env, downloadfrom):
    hostn = socket.gethostname()
    if '/sbv-cms/' in downloadfrom or '/sbv-media/' in downloadfrom or '/sbv-stats/' in downloadfrom:
        docrootconfig = "%s/config" % (docroot)
        configfiles = [ f for f in os.listdir(docrootconfig) if os.path.isfile(os.path.join(docrootconfig, f)) ]
        # hostconfig = config.ini.uid1v-aarwine
        # envconfig = config.ini.dev
        # roleconfig = config.ini.media
        role = hostn.split('.')[0].split('-')[1]
        hostconfig = "config.ini.%s" % hostn.split('.')[0]
        envconfig = "config.ini.%s" % env
        roleconfig = "config.ini.%s" % role
        configfile = False
        if envconfig in configfiles:
            configfile = envconfig
        if roleconfig in configfiles:
            configfile = roleconfig
        if hostconfig in configfiles:
            configfile = hostconfig
        if not configfile:
            # Statically configured trash names
            if env == 'stg':
                if role == 'cms':
                    print "WARNING: Deprecated config filename found"
                    configfile = 'config.ini.stg_rw'
                if role == 'media':
                    print "WARNING: Deprecated config filename found"
                    configfile = 'config.ini.stg_r'
            if env == 'prd':
                if role == 'cms':
                    print "WARNING: Deprecated config filename found"
                    configfile = 'config.ini.lax_rw'
                if role == 'media':
                    print "WARNING: Deprecated config filename found"
                    configfile = 'config.ini.lax_r'
            if not configfile:
                print "ERROR: config file not found."
                sys.exit(1)
        hostconfigphp = "config.php.%s" % hostn.split('.')[0]
        envconfigphp = "config.php.%s" % env
        roleconfigphp = "config.php.%s" % role
        configphpfile = False
        if envconfigphp in configfiles:
            configphpfile = envconfigphp
        if hostconfigphp in configfiles:
            configphpfile = hostconfigphp
        if configphpfile:
            print "Discovered config.php file: %s" % configphpfile
            print "Copying config.php file %s -> %s" % (os.path.join(docrootconfig, configphpfile), os.path.join(docrootconfig, 'config.php'))
            shutil.copyfile(os.path.join(docrootconfig, configphpfile), os.path.join(docrootconfig, 'config.php'))
        print "Copying config.ini file %s -> %s" % (os.path.join(docrootconfig, configfile), os.path.join(docrootconfig, 'config.ini'))
        shutil.copyfile(os.path.join(docrootconfig, configfile), os.path.join(docrootconfig, 'config.ini'))
        for rmfile in configfiles:
            if rmfile.startswith('config.ini.') or rmfile.startswith('config.php.'):
                print "Removing unused config file: %s" % rmfile
                os.remove(os.path.join(docrootconfig, rmfile))
        # /app/shared/docroots/publishers.springboard.gorillanation.com/htdocs/wp/springboard-video-quick-publish/admin/config/config.php
        # We need to allow apache to edit the wp plugin config
        # os.chown(path, uid, gid)
        # deploy = 10028
        # This next script should only run on cms boxes when sbv-cms is being deployed.
        if 'media' not in hostn:
            print "Changing ownership of wp plugin config.php"
            wpconfig = "%s/%s" % (docroot, 'wp/springboard-video-quick-publish/admin/config/config.php')
            os.chmod(wpconfig, 0777)
        # chown tmp
        for root, dir, file in os.walk("%s/tmp" % docroot):
            print 'Opening up tmp dir permissions on:', root
            os.chmod(root, 0777)
    if '/sbv-yourls/' in downloadfrom:
        docrootconfig = "%s/user" % (docroot)
        configfiles = [ f for f in os.listdir(docrootconfig) if os.path.isfile(os.path.join(docrootconfig, f)) ]
        configfile = ""
        if "config.php.%s" % env in configfiles:
            configfile = "config.php.%s" % env
            print "Copying config.php file %s -> %s" % (os.path.join(docrootconfig, configfile), os.path.join(docrootconfig, 'config.php'))
            shutil.copyfile(os.path.join(docrootconfig, configfile), os.path.join(docrootconfig, 'config.php'))
        else:
            print "Error: no config file found"
        for dfile in configfiles:
            if dfile.startswith('config.php.'):
                print "Removing unused config file: %s" % dfile
                os.remove(os.path.join(docrootconfig, dfile))



def mktmpdir(docroot):
    # docroot is newpath...
    tmpdir = "%s/tmp" % (docroot)
    print "making tmp dir at: %s" % tmpdir
    os.mkdir(tmpdir)

def symlinkSwing(symlinkLoc, symlinkTar):
    print "removing old symlink"
    print symlinkLoc
    os.unlink(symlinkLoc)
    print "adding new symlink"
    os.symlink(symlinkTar, symlinkLoc)

def restartApache():
        syscallStdout = []
        syscallStderr = []
        cmd = 'sudo /sbin/service httpd graceful'
        syscall = cmd.split()
        print("Restarting apache on: %s" % (socket.getfqdn()))
        p = subprocess.Popen(syscall, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        for line in iter(p.stdout.readline, ""):
            stdoutLine = line.strip() + '\r\n'
            syscallStdout.append(stdoutLine)
            sys.stdout.write(stdoutLine)
            sys.stdout.flush()
        for line in iter(p.stderr.readline, ""):
            stderrLine = line.strip() + '\r\n'
            syscallStderr.append(stderrLine)
            sys.stderr.write(stderrLine)
            sys.stderr.flush()
        return (syscallStdout, syscallStderr)

symlinkpath = args.symlink
downloadfrom = args.pkgurl
onlypostscripts = args.onlypostscripts

deploypath = os.path.dirname(symlinkpath)
downloadto = "%s/%s" % (deploypath, os.path.basename(downloadfrom))
commonbase = os.path.dirname(symlinkpath)
olddir = os.readlink(symlinkpath)
oldpath = os.path.join(commonbase, olddir)
newpath = os.path.join(commonbase, incrementLastPiece(olddir))


if not onlypostscripts:
    print "### Downloading: %s -> %s" % (downloadfrom, downloadto)
    downloadBuild(downloadfrom, downloadto)
    print "### Deploying to %s" % newpath
    untar(downloadto, newpath)
    print "### Running post MOVE scripts"
    postMoveScripts(downloadfrom, newpath)
    print "### Swinging symlinks:"
    print "###### %s -> %s" % (oldpath, newpath)
    symlinkSwing(symlinkpath, newpath)



print "### Running post DEPLOY scripts"
postDeployScripts()

print "### Deleting cruft:"
if os.path.exists(downloadto):
    print "###### tarball: %s" % downloadto
    os.remove(downloadto)
if os.path.exists(oldpath):
    if os.readlink(symlinkpath) != oldpath:
        print "###### old code: %s" % oldpath
        shutil.rmtree(oldpath)
