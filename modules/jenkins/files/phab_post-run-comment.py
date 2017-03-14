#!/usr/bin/env python
"""
Copyright 2013 Disqus, Inc.
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""
 
import json
import os
import sys
import urllib
 
from phabricator import Phabricator
 
if __name__ == '__main__':
    jenkins_build_url = os.environ['BUILD_URL']
 
    console_output_url = jenkins_build_url + "console"
    test_report_url = jenkins_build_url + "aggregatedTestReport/"
    build_data_url = jenkins_build_url + "api/json"
 
    p = Phabricator(host='http://phabricator.gnmedia.net/api/')
 
    diff_id = os.environ['DIFF_ID']
    differential = p.differential.querydiffs(ids=[diff_id])
    differential_id = differential[diff_id]['revisionID']
 
    print "Reading Jenkins Status..."
    data = json.load(urllib.urlopen(build_data_url))
 
    result = data['result']
 
    if result == "FAILURE":
        actions = data['actions']
 
        num_failures = 0
        for a in actions:
            if 'failCount' in a:
                num_failures = a['failCount']
 
        print "D%s failed tests on diff id %s" % (differential_id, diff_id)
 
        if int(num_failures) == 0:
            message = "Jenkins is unable to run tests with this patch. See %s to see why." % console_output_url
        else:
            message = "This patch causes %s tests to fail! See %s to see which tests are failing." % (num_failures, test_report_url)
 
        action = "reject"
        silent = False
 
    elif result == "SUCCESS":
        print "D%s passed all tests with diff id %s" % (differential_id, diff_id)
        message = "This patch does not break any tests. +1. See the passing build here: %s" % test_report_url
        action = "none"
        # This comment should not email everyone.
        silent = True
 
    # If the jenkins job was ABORTED or any other state.
    else:
        print "Jenkins status is: %s. Exiting." % result
        sys.exit(0)
 
    # This will fail if the differential has been closed already or if
    # phabricator is not working correctly. We should silently fail and print
    # out the exception for debugging. By catching the exception we prevent the
    # error code of the script from being not 0.
    try:
        print "Creating comment: %s" % message
        print "Comment has type: %s" % action
        p.differential.createcomment(revision_id=int(differential_id), message=message, action=action, silent=silent)
    except BaseException as e:
        print "Exception When Trying to Create Comment"
        print e
