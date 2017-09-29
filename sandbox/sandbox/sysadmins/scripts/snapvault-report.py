#!/usr/bin/python
#
# snapvault-report.py
#
# Script to take output from rnetapp and find missing, stale, or orphaned snapvaults
#
# 04222013 aarwine and rkruszewski
#
###

import subprocess, smtplib
from email.MIMEText import MIMEText
import re
from optparse import OptionParser

# for debugging; sys.exit()
import sys


###
#
#  Configuration
#
###


rnetappLoc = "/usr/bin/rnetapp"

# filerDict sets up where each filer snapvaults to. In the form of filerDict['SOURCE'] = "DEST"
filerDict = {}
filerDict['nfs1.netapp3.gnmedia.net'] = "nfs1.netapp2.gnmedia.net"
filerDict['nfs2.netapp3.gnmedia.net'] = "nfs2.netapp2.gnmedia.net"

# toggle to enable output to screen. Valid values are True | False.  Can be overridden with -e switch.
enableStdOut = True

# toggle to enable output to email.  Valid values are True | False.  Can be overridden with -e switch.
enableEmail = False

# Email settings
ffrom = "Netapp Weekly Report <TechnologyPlatform@gorillanation.com>"
#tto = "richard.kruszewski@gorillanation.com"
tto = "sysadmins@gorillanation.com"
subject = "Snapvault Weekly Report"

# Max snapvault age: maximum age in hours a snapvault can be before being considered "stale." Must be an integer. 
maxSnapAge = 24

# Whitelist: Include volumes that would otherwise be excluded from output.  Format:  volume name without /vol/
#whiteList = ("nfs1_sql1v_vipvisual_tp_prd_lax_binlog")
whiteList = ()

# Blacklist: Exclude hosts that would otherwise be included from output. Format:  volume name without /vol/
blackList = ("hcabral_test", "hcabral2_test", "kitchentesting", "nfs1_tp_lax_prd_app_svnrepos", "nfs2_tp_lax_prd_app_shared", "nfs1_ci_lax_prd_mem_kestrel", "nfs2_ci_lax_prd_mem_kestrel")
#blackList = ()

# Default blacklist: default regex pattern used to exclude volumes - e.g. SQL, DEV, or STG - from output.
defBlackList = re.compile('^nfs[0-9]+_sql|^nfs[0-9]+_uid|^nfs[0-9]+_vm_images|^vol0|.*_(dev|stg)_|.*_binlog$|.*_data$|.*(app|em|mem|pxy|spx|sql)_log$|.*_spx_shared$|.*_tmp$')



###
#
# Function Definitions
#
###



## Let's get a list of all volumes for each filer.
def getVolumeList(filerDict):
    volumes = []
    for filer in filerDict:
        sysCall = "%s %s volume list" % (rnetappLoc, filer)
        sysCall = sysCall.split()
        p = subprocess.Popen(sysCall, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        for line in iter(p.stdout.readline, ""):
            # omit the header from the rnetapp volume list output
            if line.split() != ['Volume', 'Name', 'Total', 'Used', 'Use', 'State'] and not line.split()[0].startswith('sv_'):
                volumes.append((filer, line.split()[0]))
    return volumes



## Let's get a list of all qtrees for a given filer
def getQtreeList(filerDict):
    qtrees = []
    for filer in filerDict:
        sysCall = "%s %s qtree list" % (rnetappLoc, filer)
        sysCall = sysCall.split()
        p = subprocess.Popen(sysCall, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        for line in iter(p.stdout.readline, ""):
            # omit the header from the rnetapp qtree list output
            if line.split() != ['Volume', 'Tree', 'Style', 'Oplocks', 'Status'] and line.split() != ['--------', '--------', '-----', '--------', '---------']:
                qtrees.append((filer, line.split()))
    return qtrees



## Let's get a list of snapvaults on source filers
def getSnapvaults(filerDict):
    output = []
    for filer in filerDict:
        sysCall = "%s %s snapvault status -v" % (rnetappLoc, filer)
        sysCall = sysCall.split()
        p = subprocess.Popen(sysCall, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        for line in iter(p.stdout.readline, ""):
            output.append((filer, line.split()))
    return output



## Let's get a list of snapvaults on destination filers, and normalize the output to be consistent.
def getSnapvaultDst(filerDict):
    # Takes filerDict, returns a list of output from destination netapp
    outputDst = []
    for entry in filerDict:
        dstFiler = filerDict[entry]
        sysCall = "%s %s snapvault status -x" % (rnetappLoc, dstFiler)
        sysCall = sysCall.split()
        p = subprocess.Popen(sysCall, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        for line in iter(p.stdout.readline, ""):
            outputLine = line.strip().split()
            if outputLine[:3] != ['No', 'snapvault', 'for']:
                # This will solve the issue of nfs1.netapp3.GNMEDIA.NET being there and hard to match against
                if outputLine[0].startswith('nfs1.netapp3.gnmedia.net') or outputLine[0].startswith('nfs2.netapp3.gnmedia.net'):
                    xform = outputLine[0].split(':')
                    # Do transform before adding - small percentage of output had fqdn.  Removing domain info from vol report, will rely on host info from filerDict in output
                    xform[0] = xform[0].replace('.gnmedia.net', '')
                    outputLine[0] = ':'.join(xform)
                if outputLine[0].startswith('nfs1.netapp') or outputLine[0].startswith('nfs2.netapp'):
                    # Do transform of hostname to match output from netapp3, which uses hyphen, so output is consistent with getSnapvaults()
                    xform = outputLine[0].split(':')
                    xform[0] = xform[0].replace('.netapp', '-netapp')
                    outputLine[0] = ':'.join(xform)
                outputDst.append((dstFiler, outputLine))
    return outputDst



## Using output from getVolumeList(), getQtreeList(), and getSnapvaults(), find volumes that are missing Snapvaults
def findMissingSnaps(volumes, qtrees, snapvaults):
    volSnapshot = []

    for filer, volume in volumes:
        # Does the volume have a full volume snapshot?
        for entry in snapvaults:
            if entry[1][0].endswith(volume):
                volSnapshot.append((filer, volume))
    # volRemaining shows volumes that require every qtree to be snapshotted
    volRemaining = set(volumes) - set(volSnapshot)
    removeFromRemaining = []
    qtreeMissing = []
    for filer, volume in volRemaining:
        missingQtrees = checkMissingQtrees(filer, volume, snapvaults, qtrees)
        if missingQtrees != []:
            # we have missing qtrees for this volume.
            qtreeMissing.append((filer, volume, missingQtrees))
        else:
           removeFromRemaining.append((filer, volume))
    volRemaining = list(volRemaining)
    for entry in removeFromRemaining:
        volRemaining.remove(entry)
    return (volRemaining, qtreeMissing)



## Used with checkMissingQtrees(), determines the qtrees for a given base volume 
def getVolQtree(filer, volumeName, qtrees, snapshots):
    # Takes filer, volumeName and qtrees. Finds the qtrees.
    results = []
    for qfiler, qtreeDetail in qtrees:
        qVolName = qtreeDetail[0]
        if qVolName == volumeName and qfiler == filer:
            if qtreeDetail[1] == 'unix':
                qtree = '-'
            else:
                qtree = qtreeDetail[1]
            results.append(qtree)
    return results



## called by findMissingSnaps(), determines missing Snapvaults for qtrees 
def checkMissingQtrees(filer, volume, snapvaults, qtrees):
        volQtrees = getVolQtree(filer, volume, qtrees, snapvaults)
        result = []
        # Strictly speaking the requirements are:
        # Return a tuple of tuples of problem qtrees
        # [(filer, volume, qtree), (filer, volume, qtree)]
        for vqtree in volQtrees:
            vqtreeGood = False
            for snap in snapvaults:
                if snap[0] == filer and snap[1][0].endswith("%s/%s" % (volume, vqtree)):
                    # If we get here, it means that this qtree is good.
                    # However, we still need to check the rest of the qtrees
                    vqtreeGood = True
            if vqtreeGood == False:
                result.append((vqtree))
        return result



## Let's check for stale snapshots on each filer - using data from getSnapvaults()
def findStaleSnaps(snapvaultList):
    stale = []
    for snapvaults in snapvaultList:
        if snapvaults[1][0] != "No":
            # Age field is of form HH:MM:SS, unless Snapvault is unitialized (NA).  Break apart and compare against first field.
            if snapvaults[1][3].split(':')[0] == "NA":
                # Formatting the output to be: (Filer, Volume Info, SnapshotAge)
                stale.append((snapvaults[0],snapvaults[1][0],snapvaults[1][3]))
            elif snapvaults[1][3].split(':')[0].isdigit():
                if int(snapvaults[1][3].split(':')[0])>maxSnapAge:    
                    stale.append((snapvaults[0],snapvaults[1][0],snapvaults[1][3]))
    return stale



## Finds orphan Snapvaults, and honors the relationship described in filerDict when comparing sets.
## Requires the output from getSnapvaults(), getSnapvaultDst()
def findSnapOrphans(srcFilerList, dstFilerList):
    orphans = []
    for filer in filerDict:
        srcf = []
        dstf = []
        srcFiler = filer
        dstFiler = filerDict[filer]
        # Ensure comparison of volumes is only for the filer relationship described in fileDict
        for line in srcFilerList:
            if line[1][0] != "No" and line[0] == srcFiler:
                srcf.append(line[1][0])
        for line in dstFilerList:
            if line[1][0] != "No" and line[0] == dstFiler:
                dstf.append(line[1][0])
        # Output the snapvaults on srcFiler who do not have a corresponding snapvault on dstFiler
        for entry in set(srcf)-set(dstf):
            orphans.append((srcFiler, entry))
        # Output the snapvaults in dstfiler who do not have a corresponding snapvault on srcFiler
        for entry in set(dstf)-set(srcf):
            orphans.append((dstFiler, entry))
    return orphans



## Uses our filter rules to filter output. Requires volume data to be volume name stripped of /vol/
def needsSnapvault(volume):
    if volume in whiteList:
        return True
    elif volume in blackList:
        return False
    elif re.match(defBlackList, volume):
        return False
    else:
        return True



def sendMail(Sender, Recipient, Subject, Body):
    msg = MIMEText(Body)
    msg['Subject'] = Subject
    msg['From'] = Sender
    msg['To'] = Recipient
    send = smtplib.SMTP('localhost')
    send.sendmail(msg['From'], [msg['To']], msg.as_string())
    send.quit



###
#
# Set up list variables and call functions
#
###

# Get command line option if present.
parser = OptionParser()

parser.add_option("-e", "--email", help="Email Snapvault report results to email address configured in script", action="store_true", dest="emailOpt")

(options, args) = parser.parse_args()


# Get all the required information from rnetapp.  Slowest portion of the script.
snapvaultList = getSnapvaults(filerDict)
snapvaultDstList = getSnapvaultDst(filerDict)
volumeList = getVolumeList(filerDict)
qtreeList = getQtreeList(filerDict)


# Act on data
snapOrphans = findSnapOrphans(snapvaultList, snapvaultDstList)
staleSnaps = findStaleSnaps(snapvaultList) + findStaleSnaps(snapvaultDstList)
missingSnaps = findMissingSnaps(volumeList, qtreeList, snapvaultList)


# Process missingSnaps and filter output
mailer = []
missingList = []
for entry in missingSnaps:
    entry.sort()
    #print
    for x in entry:
        #print "MISSING: ", x
        if needsSnapvault("%s" % x[1]):
            missingList.append(x)


# Output
# If no problems found, say so.
if len(staleSnaps) == 0 and len(snapOrphans) == 0 and len(missingList) == 0:
    mailer.append("# There were no snapvault errors. ")
else:
# Create megalist of output for printing or emailing.
    if len(staleSnaps) != 0:
        staleSnaps.sort()
        mailer.append("# The following volume Snapvaults are stale, or uninitialized (NA): ")
        for entry in staleSnaps:
            mailer.append("staleSnapv:\t%s\t%s\t%s" % (entry[0], entry[1].split(':')[1], entry[2]))

    if len(snapOrphans) != 0:
        snapOrphans.sort()
        mailer.append("# The following Snapvaults do not have a corresponding Snapvault on their source or destination filer: ")
        for entry in snapOrphans:
            mailer.append("snapvOrphans:\t%s\t%s" % (entry[0], entry[1].split(':')[1]))

    if len(missingList) != 0:
        mailer.append("# The following volumes or qtrees do not have a Snapvault set up: ")
        presort = []
        for entry in missingList:
            if len(entry) == 2:
                #mailer.append("missingSnap:\t%s\t/vol/%s" % (entry[0], entry[1]))
                presort.append("missingSnapv:\t%s\t/vol/%s" % (entry[0], entry[1]))
            elif len(entry) == 3:
                for x in entry[2]:
                    #mailer.append("missingSnap:\t%s\t/vol/%s/%s" % (entry[0], entry[1], x))
                    presort.append("missingSnapv:\t%s\t/vol/%s/%s" % (entry[0], entry[1], x))
        presort.sort()
        for y in presort:
            mailer.append(y)


# If email option specified on command line, override default print action and email results to configured email address.
if options.emailOpt:
    enableStdOut = False
    enableEmail = True

# Print to screen
if enableStdOut:
    #print "MAILER", mailer
    for line in mailer:
        print line

# Email results.  Should be default.
if enableEmail:
    sendMail(ffrom, tto, subject, '\n'.join(mailer))



