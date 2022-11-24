#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys

from Model import *
from Model_Insert import *
from AT.Model import *
import cherrypy
import re
import adns
import time
import os
import types
from Cheetah.Template import Template
from datetime import datetime, timedelta
from urlparse import urlparse


#sys.setrecursionlimit(8500)
cherrypy.config.update({'environment': 'embedded'})
Session = sessionmaker(bind=db)()
Session2 = sessionmaker(bind=db_locale)()
Session3 = sessionmaker(bind=db_buff)()
Description = {1: "In Service",
                0: "Out of Service",
              }
Description[None] = "Out of Service"

cherrypy.config.update({'environment': 'embedded'})

def insert(app_ip, sql_ip, conns, nodetype):
    try:
        if nodetype == "sql":
            x = APP_to_SQL_buff()
            x.app_ip = app_ip
            x.sql_ip = sql_ip
        else:
            x = PXY_to_APP_buff()
            x.pxy_ip = app_ip
            x.app_ip = sql_ip
        x.conns = conns
        x.date_inserted = datetime.now()
        Session3.add(x)
        Session3.commit()
        Session3.closed()

    except AttributeError, err:
        return(str(err))


def delete(app_ip):
    try:
        app_servers = Session.query(\
                APP_to_SQL).filter(APP_to_SQL.app_ip == app_ip)
        if app_servers != None:
            for y in app_servers:
                Session.delete(y)
            Session.commit()
            Session.closed()
    except AttributeError, err:
        return(str(err))


def showIP():
    try:
        response = ""
        app_servers = Session.query(APP_to_SQL).all()
        if app_servers != None:
            for y in app_servers:
                response += "%s, %s ,%s ,%s<br />" % (y.app_ip, y.sql_ip, \
                        y.conns, y.date_inserted)
            return response
    except AttributeError, err:
        return(str(err))


def htmlWrapper(html=None,wrap=True):
    if not wrap:
        return html
    htmlheader = '''
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
                   <head>
                   <title>VipVis</title>
                   <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
                     <script type="text/javascript">
                       function formfocus() {
                          document.getElementById('element').focus();
                       }
                       window.onload = formfocus;
                    </script>
            <link rel="stylesheet" href="http://vipvisual.gnmedia.net/content/jscript/jquery.treeview.css" />
                <link rel="stylesheet" href="http://vipvisual.gnmedia.net/content/jscript/demo/red-treeview.css" />
            <link rel="stylesheet" href="http://vipvisual.gnmedia.net/content/jscript/demo/screen.css" />
            <script src="http://vipvisual.gnmedia.net/content/jscript/lib/jquery.js" type="text/javascript"></script>
            <script src="http://vipvisual.gnmedia.net/content/jscript/lib/jquery.cookie.js" type="text/javascript"></script>
            <script src="http://vipvisual.gnmedia.net/content/jscript/jquery.treeview.js" type="text/javascript"></script>
            <script type="text/javascript">
            $(document).ready(function(){
                $("#browser").treeview({
                                collapsed: true,
                                animated: "fast",
                                control:"#sidetreecontrol",
                    toggle: function() {
                        console.log("%s was toggled.", $(this).find(">span").text());
                    }
                });
                $("#add").click(function() {
                    var branches =
                    $("<li><span class='folder'>New Sublist</span><ul>" +
                        "<li><span class='file'>Item1</span></li>" +
                        "<li><span class='file'>Item2</span></li></ul></li>").appendTo("#browser");
                    $("#browser").treeview({
                        add: branches
                    });
                });
            });
            </script>
                </head><body>'''
    htmlclose = '''</body></html>'''
    output = "".join([htmlheader, html, htmlclose])
    return output

def extract(hostname=None, dns="Google DNS"):
    try:
        skip_mapping = 0
        ip = None
        response = "<br />"
        host_name = ""
        #print "looking up ", hostname
        if dns == "Google DNS":
            dns_ip = "8.8.8.8"
        elif dns == "Internal DNS":
            dns_ip = "10.2.10.23"
        else:
            dns_ip = "10.2.10.23"
        if re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', hostname):
            ip_ext = Session.query(Ipmap).filter(\
                    Ipmap.in_ip == hostname).first()
            if ip_ext:
                skip_mapping = 0
                host_name = Session.query(Ipmap).filter(\
                        Ipmap.in_ip == hostname).first()
            else:
                skip_mapping = 1
                ip = Session.query(IP).filter(IP.address == hostname).first()
        else:
            s = adns.init(adns.iflags.noautosys, \
                    sys.__stderr__, "nameserver " + dns_ip)
            url = urlparse(hostname)
            if "http" in url.scheme:
                print 'url', url
                hostname = url.netloc
                print 'hostname 1', hostname
            else:
                hostname = url.path
                print 'hostname 2', hostname
            print 'hostname', hostname
            resolve = s.synchronous(hostname, adns.rr.A)
            print 'resolve', resolve
            if len(resolve[3]) == 0:
                if not re.match('(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})\.(?:[\d]{1,3})', resolve[1]):
                    resolve = s.synchronous(resolve[1], adns.rr.A)
                    print 'Cname'
                else:
                    return "Domain doesn't exist."
            ext_ip = resolve[3][0]
            # Need to validate if it's External ip
            if re.match('(72)\.(172)\.(?:[\d]{1,3})\.(?:[\d]{1,3})', ext_ip):
                if dns == "Google DNS":
                    host_name = Session.query(Ipmap).filter(\
                            Ipmap.in_ip == ext_ip).first()
            else:
                print "internal IP"
                skip_mapping = 1
                ip = Session.query(IP).filter(\
                    IP.address == ext_ip).first()
                print ip
        if host_name != None and skip_mapping == 0:
            response += "EXT IP: %s <br /> INT IP: %s<br />" % \
                    (host_name.in_ip, host_name.out_ip)
            ip = Session.query(IP).filter(\
                    IP.address == host_name.out_ip).first()
        if ip != None:
            for device_node in ip.device:
                rserver_dict = {}
                #import pdb; pdb.set_trace()
                for x in device_node.breadth_first(device_node.children):
                    if x.getType().name == "rserver":
                        # Need to consider what if it doesn't have a hostname "Blank"
                        if x.getHostname():
                            # TODO, need to consider multiple parent situation
                            rserver_dict[x.getHostname()]=x.get_status(x.parent[0],html=False)
                print "start..."
                print device_node._getstring(0, True)
                print "end ..."
                response += '<div id="sidetreecontrol"><a href="?#">Collapse All</a> | <a href="?#">Expand All</a></div>'
                response += device_node._getself_html()
                response += device_node._gethtmltree(0, True)
                # verify result is dictionary
                if isinstance(rserver_dict, types.DictType):
                    keys = rserver_dict.items()
                    keys.sort()
                    for server, status in keys:
                        if '-inv' not in server:
                           response += '<br />' + server
                

        #os.system('/var/www/html/vip-visual/cli_query.py %s'% hostname)
        return response

    except Exception, err:
        return(str(err))


class Root:

    def index(self, wrap=True):
        try:
            # Ask for the user's name.
            rev = Session.query(Revision).first()
            revision = rev.revision
            insert_time = rev.date_inserted
            return htmlWrapper('''
                <form action="extractServer" method="GET">
                External Site Name:
                <input type="text" id="element" name="value" />

                <input type="submit" />
                </form>''' + "Last updated time: [R%s] [%s] -VipVis&trade;" %  \
                (revision, insert_time), wrap)
        except Exception, err:
            return(str(err))

    index.exposed = True

    def extractServer(self, value=None, dns="Google DNS"):

        if value:
            Session.close()
            Session2.close()
            return htmlWrapper("".join([self.index(False), extract(value, dns)]))
        else:
            if value is None:
                return 'Please enter the value <a href="./">here</a>.'
            else:
                return 'please enter the value <a href="./">here</a>.'
    extractServer.exposed = True

    def graphite(self, hostname=None, frm=None, until=None):
        try:
            hostname = hostname.replace('.', '_')
            print hostname
            if frm == "-1hours":
                return Template(\
                        file='/app/shared/vipvisual/\
templates/graphite-live.tmpl', \
                    searchList=[{'hostname': hostname}]).respond()
            else:
                return Template(\
                        file='/app/shared/vipvisual/templates/graphite.tmpl',
                    searchList=[{\
                            'hostname': hostname, \
                            'from':frm, 'until':until}]).respond()
        except Exception, err:
            return(str(err))
    graphite.exposed = True

    def insertNode(self, app_ip=None, sql_ip=None, pxy_ip=None, conns=0, nodetype=None):
        # This is proxy ip
        if pxy_ip == None:
            insert(app_ip, sql_ip, conns, nodetype)
        else:
            insert(pxy_ip, app_ip, conns, nodetype)
        return 'value app_ip:%s, sql_ip:%s, pxy_ip:%s , conns:%s, node:%s' % (\
                app_ip, sql_ip, pxy_ip, conns, nodetype)
    insertNode.exposed = True

    def deleteNode(self, app_ip=None):
        delete(app_ip)
        return 'value %s' % (app_ip)
    deleteNode.exposed = False

    def showNode(self):
        return(showIP())
    showNode.exposed = True

application = cherrypy.tree.mount(Root(), "/")

if __name__ == '__main__':
    import os.path
    thisdir = os.path.dirname(__file__)
    cherrypy.server.socket_host = '0.0.0.0'
    cherrypy.server.socket_port = 8080
    cherrypy.quickstart(application)