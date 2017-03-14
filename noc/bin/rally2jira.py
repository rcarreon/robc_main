#!/usr/bin/env python

from __future__ import print_function

import os
import base64
import tempfile
import subprocess
import optparse
import ConfigParser
import getpass
import base64
import re

import html2text
import pyral
from jira.client import JIRA

def kind_of_story(rally_story_id):
    kind = re.match(r"^(..)\d+$", rally_story_id).group(1)

    if kind == "US":
        return ["UserStory", "Story"]
    elif kind == "DE":
        return ["Defect", "Bug"]

def html2confluence(html):
    tmp = tempfile.mkstemp()[1]
    with open(tmp, "w") as fh:
        h = html2text.HTML2Text()
        h.body_width = 0
        fh.write(h.handle(html))
        fh.close()
    confluence = subprocess.Popen(["markdown2confluence", tmp],
                                  stdout=subprocess.PIPE,
                                  stderr=subprocess.PIPE).communicate()[0]
    os.remove(tmp)
    return confluence

def options():
    settings = {
        "rally": {},
        "jira": {}
    }

    parser = optparse.OptionParser()
    parser.add_option("--rally-server", dest="rally_server",
                      help="Rally server", default="rally1.rallydev.com")
    parser.add_option("--rally-source-project", dest="rally_source_project",
                      help="Rally project")
    parser.add_option("--rally-source-stories", dest="rally_source_stories",
                      help="Rally Stories IDs. Comma-delimited")
    parser.add_option("--import-into-jira", dest="import_into_jira",
                      help="Import the Rally stories into JIRA", action="store_true")
    parser.add_option("--jira-server", dest="jira_server",
                      help="JIRA server", default="https://evolvemediallc.atlassian.net")
    parser.add_option("--jira-target-project", dest="jira_target_project",
                      help="JIRA project key in which the Rally stories will be imported")
    parser.add_option("--jira-on-behalf-of", dest="jira_on_behalf_of",
                      help='User that will "own" the story/issue/task')
    options, _ = parser.parse_args()

    if not options.rally_source_project:
        parser.error("A Rally Project is required")

    if not options.rally_source_stories:
        parser.error("A Rally Story ID is required")

    settings["rally"]["server"] = options.rally_server
    settings["rally"]["project"] = options.rally_source_project
    settings["rally"]["stories"] = options.rally_source_stories.split(",")
    settings["import_into_jira"] = options.import_into_jira        

    config_file = os.path.expanduser("~/.rally2jira.ini")
    if os.path.exists(config_file):
        config = ConfigParser.ConfigParser()
        config.read(config_file)

        settings["rally"]["username"] = config.get("rally", "username")
        settings["rally"]["password"] = config.get("rally", "password")

        settings["jira"]["username"] = config.get("jira", "username")
        settings["jira"]["password"] = config.get("jira", "password")
    else:
        settings["rally"]["username"] = raw_input("Rally username: ")
        settings["rally"]["password"] = getpass.getpass("Rally password: ")

        settings["jira"]["username"] = raw_input("JIRA username: ")
        settings["jira"]["password"] = getpass.getpass("JIRA password: ")

    if settings["import_into_jira"]:
        settings["jira"]["server"] = options.jira_server

        if not options.jira_target_project:
            parser.error("A JIRA Project key is quite necessary to proceed")

        settings["jira"]["project"] = options.jira_target_project

        if options.jira_on_behalf_of:
            settings["jira"]["on_behalf_of"] = options.jira_on_behalf_of
        else:
            settings["jira"]["on_behalf_of"] = settings["jira"]["username"]

    return settings

def main():
    settings = options()
    rally = pyral.Rally(settings["rally"]["server"],
                        settings["rally"]["username"],
                        settings["rally"]["password"],
                        project=settings["rally"]["project"])

    import_into_jira = settings["import_into_jira"]

    jira = None
    if import_into_jira:
        jira = JIRA(
            server=settings["jira"]["server"],
            basic_auth=(settings["jira"]["username"], settings["jira"]["password"])
        )

    stories = [rally.get(kind_of_story(story)[0], query='FormattedID = "{0}"'.format(story)).next() for story in settings["rally"]["stories"]]

    # Weep for me...
    for story in stories:
        if import_into_jira:
            issue = jira.create_issue(
                project={"key": settings["jira"]["project"]},
                summary=story.Name,
                description=html2confluence(story.Description),
                reporter={"name": settings["jira"]["on_behalf_of"]},
                issuetype={"name": kind_of_story(story.FormattedID)[1]}
            )
            header = "{0} -> {1}: {2}".format(story.FormattedID, issue.key, story.Name)
        else:
            header = "{0}: {1}".format(story.FormattedID, story.Name)

        print(header)

        names = []
        for attachment in story.Attachments:
            names.append(attachment.Name)

            if import_into_jira:
                tmp = tempfile.mkstemp()[1]

                with open(tmp, "wb") as fh:
                    fh.write(base64.b64decode(attachment.Content.Content))
                    fh.close()

                jira.add_attachment(issue.key, tmp, attachment.Name)
                os.remove(tmp)

        print("\tAttachments: " + ", ".join(names))

        print("\tDiscussion:")
        for ConversationPost in story.Discussion:
            print("\t\t{0}:".format(ConversationPost.User.Name))
            print("\n".join(["\t\t" + line for line in html2confluence(ConversationPost.Text).split("\n")]))

            if import_into_jira:
                jira.add_comment(issue=issue.key,
                                 body=html2confluence(
                                     "On behalf of {0}:<br/><br/>{1}".format(ConversationPost.User.Name,
                                                                             ConversationPost.Text)))

        # ...a little more
        for rally_task in story.Tasks:
            jira_task = None
            if import_into_jira:
                jira_task = jira.create_issue(
                    project={"key": settings["jira"]["project"]},
                    parent={"key": issue.key},
                    summary=rally_task.Name,
                    description=html2confluence(rally_task.Description),
                    reporter={"name": settings["jira"]["on_behalf_of"]},
                    issuetype={"id": "5"}
                )
                header = "\t{0} -> {1}: {2}".format(rally_task.FormattedID, jira_task.key, rally_task.Name)
            else:
                header = "\t{0}: {1}".format(rally_task.FormattedID, rally_task.Name)
            
            print(header)

            names = []
            for attachment in rally_task.Attachments:
                names.append(attachment.Name)

                if import_into_jira:
                    tmp = tempfile.mkstemp()[1]

                    with open(tmp, "wb") as fh:
                        fh.write(base64.b64decode(attachment.Content.Content))
                        fh.close()

                    jira.add_attachment(jira_task.key, tmp, attachment.Name)
                    os.remove(tmp)

            print("\t\tAttachments: " + ", ".join(names))

            print("\t\tDiscussion:")
            for ConversationPost in rally_task.Discussion:
                print("\t\t\t{0}:".format(ConversationPost.User.Name))
                print("\n".join(["\t\t\t" + line for line in html2confluence(ConversationPost.Text).split("\n")]))

                if import_into_jira:
                    jira.add_comment(issue=jira_task.key,
                                     body=html2confluence(
                                         "On behalf of {0}:<br/><br/>{1}".format(ConversationPost.User.Name,
                                                                                 ConversationPost.Text)))

if __name__ == "__main__":
    main()

