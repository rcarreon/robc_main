#!/usr/bin/env python

import rpmUtils.transaction
import yum
from yum.misc import getCacheDir

depsPkgList = []

ts = rpmUtils.transaction.initReadOnlyTransaction()
lp = yum.packages.YumLocalPackage(ts, "/mnt/yum_repos/wildwest/epel/5/memcached-1.4.5-1.el5.x86_64.rpm")


yb = yum.YumBase()
yb.repos.setCacheDir(getCacheDir())
yb.repos.disableRepo("*")

yb.add_enable_repo("ww-epel", ["http://yum.gnmedia.net/wildwest/epel/5/"])
yb.add_enable_repo("ww-ius", ["http://yum.gnmedia.net/wildwest/ius/5/"])
yb.add_enable_repo("ww-os", ["http://yum.gnmedia.net/wildwest/centos/5.6/os/"])
yb.add_enable_repo("ww-updates", ["http://yum.gnmedia.net/wildwest/centos/5.6/updates/"])


depDict = yb.findDeps([lp])
#print depDict

for pkgName, deps in depDict.iteritems():
	for entry in deps:
		if len(deps[entry]) == 1:
			if deps[entry] not in depsPkgList:
				depsPkgList.append(deps[entry])
		else:
			bestPackage = yb.bestPackagesFromList(deps[entry])
			if bestPackage not in depsPkgList:
				depsPkgList.append(bestPackage)

print depsPkgList

#print depsPkgList


