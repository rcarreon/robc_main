#!/usr/bin/python
# 
# 17:02:40 < skvidal> look up remotepath and you'll url and what not
# To find the filename

import os, sys, subprocess, shutil, string, logging
import rpmUtils.transaction
import yum
from optparse import OptionParser
from yum.misc import getCacheDir

baseDir = "/mnt/yum_repos"
yumBaseUrl = "http://yum.gnmedia.net"
logFile = "/var/log/yum-cherrypick.log"
logLevel = logging.INFO
runningUser = os.getlogin()

foundList = []
resultList = []
lostList = []
possibleDeps = []
finalDeps = []
createRepoList = []

usage = "usage: %prog [options] searchname"
parser = OptionParser(usage=usage, version="%prog 0.82")
parser.add_option("-c", "--centosversion", dest="osVersion", help="Version of CentOS to cherrypick for", metavar="(5|6)", default="5")
parser.add_option("-d", "--destination", dest="destinationRepo", help="what branch of repo are you cherrypicking to?", metavar="(beta|live)", default="beta")
parser.add_option("-g", "--gnrepo", dest="gnrepo", action="store_true", default=False, help="Use this when you are cherry picking an rpm from anywhere. IE form your home dir.")
(options, args) = parser.parse_args()

if os.getuid() != 0:
	parser.error("Must be run with root privs. Through sudo.")
if runningUser == "root":
	parser.error("Must run with sudo")

logger = logging.getLogger('yumCherryPick')
hdlr = logging.FileHandler(logFile)
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
hdlr.setFormatter(formatter)
logger.addHandler(hdlr)
logger.setLevel(logLevel)

logger.info("%s - %s" % (runningUser, ' '.join(sys.argv)))

def createrepo(linkLocation, osver):
    ### This function will create the metadata for a repo. Generally you'll only want to use this
    # on repos that have been changed (had something linked). It will show realtime data on which
    # RPM it's currently gathering metadata for.
	
    # I used to think this was needed. Now I think I was retarded.
    # This was commented out on april 3rd; feel free to just remove it after a good amount of time
    # linkBaseName = os.path.dirname(linkLocation)
    linkBaseName = linkLocation
    print "Rebuilding metadata for %s" % linkBaseName
    logger.info("%s - Rebuilding metadata for %s" % (runningUser, linkBaseName))
    if osver == "5":
        sysCall = "createrepo --checksum=sha %s" % linkBaseName
    if osver == "6":
        sysCall = "createrepo %s" % linkBaseName
    else:
        logger.warning("OS Version does not seem to be recognized.")
    sysCall = sysCall.split()
    p = subprocess.Popen(sysCall, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    for line in iter(p.stdout.readline, ""):
        sys.stdout.write(line.strip() + '\r\n')
        sys.stdout.flush()

def searchRepos(osWalkOutput, searchString):
	### This function will search through the output of oswalk, and return a list of tuples
	# ( root, filename ) which is just the full path - "%s/%s" % ( root, filename)
	output = []
	for root, dirs, files in osWalkOutput:
		for entry in files:
			if searchString.lower() in entry.lower() and entry.endswith(".rpm"):
				output.append((root, entry))
	return output

def searchPackages(osWalkOutput, searchString, srcRepo):
	### This function is needed because searchRepos didn't have an option to choose which repo (wildwest, beta, live)
	# I wish there was a cleaner way to do it.
	output = []
	for root, dirs, files in osWalkOutput:
		for entry in files:
			if searchString.lower() in entry.lower() and entry.endswith(".rpm"):
				if srcRepo.lower() in root.lower():
					output.append((root, entry))
	return output

def createLink(srcRpm, linkLocation):
	### This function will check to see if a link is already created and if it's not
	# it will create it.
	print "Linking %s to %s" % (srcRpm, linkLocation)
	logger.info("%s - Linking %s to %s" % (runningUser, srcRpm, linkLocation))
	if os.path.isfile(linkLocation):
		print "file already exists %s" % linkLocation
		logger.warning("%s - file already exists %s" % (runningUser, linkLocation))
	else:
		os.link(srcRpm, linkLocation)

def sortResults(foundList):
	### This function sorts the found rpms and puts them all into resultsList
	# assign var in function so I don't run into scope issues
	resultList = []
	for entry in foundList:
		if entry[0].endswith("epel/5") and osVersion == "5":
			resultList.append(entry)
		elif "centos/5.6/os/" in entry[0] and osVersion == "5":
			resultList.append(entry)
		elif "centos/6.0/os/" in entry[0] and osVersion == "6":
			resultList.append(entry)
		elif "centos/6.2/os/" in entry[0] and osVersion == "6":
			resultList.append(entry)
		elif "centos/6.4/os/" in entry[0] and osVersion == "6":
			resultList.append(entry)
		elif entry[0].endswith("epel/6") and osVersion == "6":
			resultList.append(entry)
		elif entry[0].endswith("ius/5") and osVersion == "5":
			resultList.append(entry)
		elif entry[0].endswith("ius/6") and osVersion == "6":
			resultList.append(entry)
		elif entry[0].endswith("gnrepo/5") and osVersion == "5":
			resultList.append(entry)
		elif entry[0].endswith("gnrepo/6") and osVersion == "6":
			resultList.append(entry)
		elif entry[0].endswith("nodejs/5") and osVersion =="5":
			resultList.append(entry)
		elif entry[0].endswith("nodejs/6") and osVersion == "6":
			resultList.append(entry)
		else:
			# if we got here, it means that I'm not quite sure where it came from, so append it to LostList
			# so we can investigate
			if entry[0][0].endswith("/debug") or entry[0][0].endswith("/debuginfo"):
				lostList.append(entry)
	resultList = sorted(resultList)
	return resultList

def getDeps(pkgObj):
    depDicts = yb.findDeps([pkgObj])
    deps = cleanDeps(depDicts)
    finalDeps = deps
    return deps

def cleanDeps(depDict):
    depsPkgList = []
    for pkgName, deps in depDict.iteritems():
        for entry in deps:
	    if len(deps[entry]) == 1:
	        if deps[entry] not in depsPkgList:
	        	depsPkgList.append(deps[entry])
	    else:
		bestPackage = yb.bestPackagesFromList(deps[entry])
		if bestPackage not in depsPkgList:
        		depsPkgList.append(bestPackage)
    if [] in depsPkgList:
        logger.info("%s - %s" % (runningUser, "Warning: cleanDeps returned and subsequently removed a blank dependency"))
        print "Warning: The function cleanDeps() has resulted in a blank dependency and will be removed"
        print "Original deps:", depsPkgList
        depsPkgList.remove([])
        print "New deps:", depsPkgList
    return depsPkgList

def rePkgDeps(depsPkgList):
	# It's now parsed into some form of a 2d list, so this next block will return a clean and
	# concise [['fullFilePath', pkgName], ['fullFilePath', pkgName]]
        fullPathRpm = srcRpm
	resultsList = []
	for entry in depsPkgList:
		if len(entry) == 1:
			if [entry[0].remote_url.replace(yumBaseUrl, baseDir), entry[0]] not in resultsList:
				if entry[0].remote_url.replace(yumBaseUrl, baseDir).split('/')[-1] != fullPathRpm.split('/')[-1]:
					resultsList.append([entry[0].remote_url.replace(yumBaseUrl, baseDir), entry[0]])
		else:
			for i in range(0,len(entry)):
				if [entry[i].remote_url.replace(yumBaseUrl, baseDir), entry[i]] not in resultsList:
					if entry[i].remote_url.replace(yumBaseUrl, baseDir) != fullPathRpm.split('/')[-1]:
						resultsList.append([entry[i].remote_url.replace(yumBaseUrl, baseDir), entry[i]])
	return resultsList
    

#######################
#     # MAIN () #     #
#######################

if len(args) != 1:
	parser.print_help()
	parser.error("incorrect number of arguments")


searchString = args[0]
osVersion = options.osVersion
destinationRepo = options.destinationRepo
gnValue = options.gnrepo

allowedDestinations = ["beta", "live"]
if destinationRepo in allowedDestinations:
	if destinationRepo == "beta":
		sourceRepo = "wildwest"
	elif destinationRepo == "live":
		sourceRepo = "beta"
	else:
		print "Ok, I need to be updated with acceptable destinations"
		logger.error("%s - Script needs to be updated with acceptable destinations" % runningUser)
else:
	print "Y U HAVE TO BE DIFFERENT - Give me a destination I understand"
	logger.error("%s - Script doesn't understand the given destination" % runningUser)

sourceDir = "%s/%s" % ( baseDir, sourceRepo ) 

# Check to see if -gn is set. If it is; we're skipping all the searching crap
if gnValue:
	linkLocation = "%s/beta/gnrepo/%s/%s" % (baseDir, osVersion, os.path.basename(searchString))
	shutil.copy(searchString, linkLocation) 
	createrepo(os.path.dirname(linkLocation), osVersion)
	sys.exit()

# TODO: This is horrible and needs to be changed; just not now.
if osVersion == "6":
	centosVersion = "6.4"
elif osVersion == "5":
	centosVersion = "5.6"


# Do the searching, and create a "foundList" that we can parse
# through later
## I spent a long time trying to figure out why osWalkOutput disappeared after it's first use.
## osWalkOutput = list(...) solves that problem because it will convert to a list and store it in memory
## instead of ending up with a stale empty memory reference
osWalkOutput = list(os.walk(sourceDir))
foundList = searchPackages(osWalkOutput, searchString, sourceRepo)

# Parse through found list woooo
resultList = sortResults(foundList)


if len(resultList) == 0:
	print 'Error: No rpm found with %s in the name' % searchString
	sys.exit()

titleVar = ""

print 'Search results for: %s' % searchString
for i in range(len(resultList)):
	# This block of code determines whether we need to print a new "title" line
	newtitle = resultList[i][0].split('/')
	newtitle = newtitle[-2:]
	newtitle = ''.join(newtitle) + ':'
	if titleVar != newtitle:
		print newtitle
		titleVar = newtitle
	print "\t%s. %s" % (i, resultList[i][1])

userInput = raw_input("Pick an RPM, or (e)xit: ")

if userInput.lower() == "e":
	sys.exit()

rpmNumber = int(userInput)
srcRpm = "%s/%s" % (resultList[rpmNumber][0], resultList[rpmNumber][1])
repoPath = resultList[rpmNumber][0].split(sourceRepo)[1]

# baseDir = /mnt/yum_repos
# destinationRepo = wildwest, beta, live
# repoPath = centos, epel, ius
# resultList[rpmNumber][1] = rpm filename
linkLocation = "%s/%s/%s/%s" % ( baseDir, destinationRepo, repoPath, resultList[rpmNumber][1] )

# CP the original request
createLink(srcRpm, linkLocation)

if linkLocation not in createRepoList:
	createRepoList.append(os.path.dirname(os.path.normpath(linkLocation)))

# Let's setup the dependency gathering vars
ts = rpmUtils.transaction.initReadOnlyTransaction()
yb = yum.YumBase()
yb.repos.setCacheDir(getCacheDir())
yb.repos.disableRepo("*")
if destinationRepo == "beta":
    # If we are CP'ing into beta we need to check wildwest for deps
    yb.add_enable_repo("epel%s-wildwest" % osVersion, ['http://yum.gnmedia.net/wildwest/epel/%s/' % (osVersion)])
    yb.add_enable_repo("ius%s-wildwest" % osVersion, ['http://yum.gnmedia.net/wildwest/ius/%s/' % (osVersion)])
    yb.add_enable_repo("os%s-wildwest" % osVersion, ['http://yum.gnmedia.net/wildwest/centos/%s/os/' % (centosVersion)])
    yb.add_enable_repo("updates%s-wildwest" % osVersion, ['http://yum.gnmedia.net/wildwest/centos/%s/updates/' % (centosVersion)])
    yb.add_enable_repo("nodejs%s-wildwest" % osVersion, ['http://yum.gnmedia.net/wildwest/nodejs/%s/' % (osVersion)])
elif destinationRepo == "live":
    yb.add_enable_repo("epel%s-beta" % osVersion, ['http://yum.gnmedia.net/beta/epel/%s/' % (osVersion)])
    yb.add_enable_repo("ius%s-beta" % osVersion, ['http://yum.gnmedia.net/beta/ius/%s/' % (osVersion)])
    yb.add_enable_repo("os%s-beta" % osVersion, ['http://yum.gnmedia.net/beta/centos/%s/os/' % (centosVersion)])
    yb.add_enable_repo("updates%s-beta" % osVersion, ['http://yum.gnmedia.net/beta/centos/%s/updates/' % (centosVersion)])
    yb.add_enable_repo("nodejs%s-beta" % osVersion, ['http://yum.gnmedia.net/beta/nodejs/%s/' % (osVersion)])
    # And GNREPO
    print 'http://yum.gnmedia.net/%s/gnrepo/%s/' % (sourceRepo, osVersion)
    yb.add_enable_repo("gnrepo-beta", ['http://yum.gnmedia.net/%s/gnrepo/%s/' % (sourceRepo, osVersion)])



lp = yum.packages.YumLocalPackage(ts, srcRpm)    

count = 0
depList = getDeps(lp)
while count < len(depList):
    partialDeps = getDeps(depList[count][0])
    for partialDep in partialDeps:
        if partialDep not in depList:
            depList.append(partialDep)
    count += 1

depList = rePkgDeps(depList)


# User has chosen the RPM, now I need to create approved / disapproved list and allow them to CP from there
## Zero step; gotta search for the rpms based off the name I have (epoch is fucking everything up)
## First step; check to see if chosen rpm is already linked. Create new list of only UNLINKED dependencies
## Second step; Unsatisfied deps: would you like to CP (a)ll (n)one (s)ome ?
### If all, cherry pick them all, if none, only cherrypick the memcached, if some it gets interesting
## Third step; Do all the hardlinking YAY we're done.
sortedDepList = sorted(depList)

# This is the place I need to check all the deps in sortedDepList to see which ones have been linked.
# Looks like sorted DepList is a 2d list each entry is ["original/path/to/file", "yumPkgObject"]
depsRemoveList = []
for entry in sortedDepList:
	tempVar = entry[0].split('/')
	tempVar[3] = destinationRepo
	if os.path.isfile('/'.join(tempVar)):
		# Dep already exists, add it to the remove queue
		depsRemoveList.append(entry)
	if destinationRepo != 'live':
		tempVar[3] = 'live'
		if os.path.isfile('/'.join(tempVar)):
			depsRemoveList.append(entry)

# If rpm is going from beta to live; remove from beta.
if destinationRepo == "live":
    os.remove(srcRpm)
    logger.info("%s - CP to live, removing %s from beta" % (runningUser, srcRpm))
    rmLinkLocation = "%s/%s/%s/%s" % ( baseDir, sourceRepo, repoPath, resultList[rpmNumber][1] )
    if rmLinkLocation not in createRepoList:
        createRepoList.append(os.path.dirname(os.path.normpath(rmLinkLocation)))


# Remove deps in the remove queue
for entry in depsRemoveList:
		sortedDepList.remove(entry)

if len(sortedDepList) != 0:
    print "Dependencies for %s:" % resultList[rpmNumber][1]
    titleVar = ""
    for i in range(0, len(sortedDepList)):
        if sortedDepList[i][0].split('/')[4] != titleVar:
            titleVar = sortedDepList[i][0].split('/')[4]
            print titleVar
        print "\t%s: %s" % (i, sortedDepList[i][1])

    # TODO: this needs to have a (s)ome option, but that's for a future version

    userInput = raw_input("Would you like to cherry pick (a)ll, (s)elective, or (n)one - (q)uit: ")

    if userInput.lower() == "q":
	sys.exit(0)

    if userInput.lower() == "s":
        # Ok, I should have a deplist somewhere; there it is. It's named sortedDepList
        # sortedDepList[i][1] = the yumPkgObject
        # sortedDepList[i][0] = the original file path
        depUserInput = raw_input("Enter the deps you'd like by number, split by space (ie: 1 2 5): ")
        if depUserInput == "":
                print "Dependency selection cannot be blank."
                logger.error('%s - Dep selection must not be blank.' % runningUser)
                sys.exit()
        desiredDeps = depUserInput.split()
        tmpSortedDepList = []
        for entry in desiredDeps:
            try:
                tmpSortedDepList.append(sortedDepList[int(entry)])
            except ValueError:
                print "Dependency selection must only be numbers / spaces."
                print 'You typed something like: %s' % depUserInput
                logger.error('%s - Dep selection included something other than numbers - %s' % (runningUser, depUserInput))
                sys.exit()
                sortedDepList = tmpSortedDepList
    if userInput.lower() == "n":
        # Why remove all the deps from the list, when you can just reset it to blank
        sortedDepList = []
    for entry in sortedDepList:
        # entry[0] is the first argument to createLink
        # entry[0]: /mnt/yum_repos/wildwest/centos/5.6/updates/RPMS/shadow-utils-4.0.17-18.el5_6.1.x86_64.rpm
        # The second argument needs to be entry[0] but in the correct repogroup (wildwest, beta, live)
        tempVar = entry[0].split('/')
        tempVar[3] = destinationRepo
        createLink(entry[0], '/'.join(tempVar))
        normPath = os.path.dirname(os.path.normpath('/'.join(tempVar)))
        if normPath not in createRepoList:
            createRepoList.append(normPath)

print "Recreating repo data for all affected repos"
for repo in createRepoList:
	createrepo(repo, osVersion)

if len(lostList) > 0:
	print "OMG WE HAVE NO HOME"
	print lostList
	logger.error('%s - Lostlist exists - %s' % (runningUser, ' '.join(lostList)))
