#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys 

#sys.path = []
#sys.path.append('/usr/local/lib/python2.6/site-packages')
#sys.path.append('/usr/local/lib/python2.6')
#sys.path.append('/usr/local/lib/python2.6/plat-linux2')
#sys.path.append('/usr/local/lib/python2.6/lib-dynload')
#sys.path.append('/usr/local/lib/python2.6/lib-old')
#sys.path.append('/usr/local/lib/python2.6/lib-tk')
sys.path.append('/app/shared/vipvisual')

from sqlalchemy import *
from sqlalchemy.orm import *
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.orm.collections import attribute_mapped_collection
from sqlalchemy.sql import func

from AT.Model import *
from Cheetah.Template import Template
from datetime import datetime, timedelta

SessionAT = sessionmaker(bind=db_locale)()

f = open('/app/shared/vipvisual/sqlhostname', 'r')
sqlhostname=f.readline()
f.close()
f = open('/app/shared/vipvisual/sqlpassword', 'r')
sqlpassword=f.readline()
f.close()

db = create_engine('mysql://vipvisual:'+sqlpassword+'@'+sqlhostname+':3306/servers_buff?\
use_unicode=1&charset=utf8',pool_size=50, \
        pool_recycle=360)
dbmetadata = MetaData()
dbmetadata.bind = db

PARENT, CHILD = (0, 1)

tree_list = []


def genCGP(hostname):
    return '<a href="http://trends.gnmedia.net/cgp/host.php?h=%s">cgp</a>'\
            % hostname


#http://graphite.gnmedia.net/render/?width=1373&height=649&_salt=\
#1307407178.086&target=app-xen10_lax1_gnmedia_net.apache.apache80.\
#apache_connections.value&from=04%3A30_20110606&until=04%3A45_20110606


def genGGP(hostname):
    real_text = '<a href="http://vipvisual.gnmedia.net/graphite/?hostname=\
%s&frm=-1hours">[ggp live]</a>' % (hostname)
    delta_time = timedelta(hours=1)
    from_time = datetime.now() - delta_time
    until_time = datetime.now()
    from_time_fmt = from_time.strftime("%H:%M_%Y%m%d")
    until_time_fmt = until_time.strftime("%H:%M_%Y%m%d")
    hr_text = '<a href="http://vipvisual.gnmedia.net/graphite/?hostname=\
%s&frm=%s&until=%s">[ggp 1hr]</a>' % (hostname, from_time_fmt, \
            until_time_fmt)
    delta_time = timedelta(hours=8)
    from_time = datetime.now() - delta_time
    until_time = datetime.now()
    from_time_fmt = from_time.strftime("%H:%M_%Y%m%d")
    until_time_fmt = until_time.strftime("%H:%M_%Y%m%d")
    eight_hr_text = '<a href="http://vipvisual.gnmedia.net/graphite\
/?hostname=%s&frm=%s&until=%s">[ggp 8hr]</a>' % \
            (hostname, from_time_fmt, until_time_fmt)
    delta_time = timedelta(hours=24)
    from_time = datetime.now() - delta_time
    until_time = datetime.now()
    from_time_fmt = from_time.strftime("%H:%M_%Y%m%d")
    until_time_fmt = until_time.strftime("%H:%M_%Y%m%d")
    day_text = '<a href="http://vipvisual.gnmedia.net/graphite/?\
hostname=%s&frm=%s&until=%s">[ggp 24hr]</a>' % \
            (hostname, from_time_fmt, until_time_fmt)
    return real_text + hr_text + eight_hr_text + day_text


def genSQL(hostname):
    if "sql" in hostname:
        return '<a href="http://toolshed.gnmedia.net/toolshed/sqlps/\
%s">[dba]</a>' % hostname
    else:
        return ""


class TreeAssoc(object):

    def __init__(self, node, parent):
        self.node = node
        self.parent = parent
        self.depth = 0


def map_model(Node, node, tree):

    class SetupDepth(MapperExtension):

        def before_insert(self, mapper, connection, instance):
            #parent = instance.parent
            #if parent and parent.assoc:
            #    instance.depth = parent.assoc.depth + 1
            #else:
            #    instance.depth = 0
            pass

    # Declare TreeAssoc
    mapper(TreeAssoc, tree, properties={
        'node': relation(Node, backref=backref('assoc', uselist=True),\
                primaryjoin=node.c.device_id == tree.c.child_id)}, \
                extension=SetupDepth())

    mapper(Node, node, properties={
        '_children': relation(TreeAssoc, backref='parent', \
                primaryjoin=node.c.device_id == tree.c.parent_id, \
                collection_class=set),
        '_types': relation(Types),
        '_silo': relation(Silo),
        '_instance': relation(Instance),
        'ips': relation(IP, secondary=ip_to_device, backref='device'),
        'details': relation(Detail, secondary=device_to_details, backref='device'),
        'predictors': relation(Predictor, secondary=device_predictor, \
                backref='device'),
        'Description': relation(Description),
    })

    # Proxy the 'node' attribute from the '_children' relation
    Node.children = association_proxy('_children', 'node', \
            creator=lambda n: TreeAssoc(n, None))
    # Proxy the 'parent' attribute from the 'assoc' relation
    Node.parent = association_proxy('assoc', 'parent', \
            creator=lambda n: TreeAssoc(None, n))

    def depth(self):
        if self.assoc:
            return self.assoc.depth
        else:
            return 0
    Node.depth = property(depth)


class IP(object):
    pass


class Host(object):
    pass

class Vlan(object):
    pass

class Vertical(object):
    pass

class Business_Owner(object):
    pass

class Environment(object):
    pass

class Types(object):

    def __str__(self):
        return self.name


class Silo(object):

    def __str__(self):
        return self.name


class Instance(object):

    def __str__(self):
        return self.name


class Revision(object):
    pass


class Detail(object):
    pass

class Interface(object):
    pass

xen_servers_hash = {}


class Device(object):

    def get_binary_status(self, parent):
        if self.getType().name != "appvip" and self.getType().name != "sqlvip":
            for x in self.assoc:
                if x.parent == parent:
                    return x.status
        return ""

    def get_status(self, parent, html=True):
        if self.getType().name != "appvip" and self.getType().name != "sqlvip":
            for x in self.assoc:
                if x.parent == parent:
                    if x.status == 1:
                        if html:
                            return '<img width="16" height="15" align="bottom" border="0" src="http://vipvisual.gnmedia.net/content/green_icon.gif">'
                        else:
                            return True
                    else:
                        if html:
                            return '<img width="16" height="15" align="bottom" border="0" src="http://vipvisual.gnmedia.net/content/red_icon.gif">'
                        else:
                            return False
        return ""

    def get_conns(self, parent):
        for x in self.assoc:
            if x.parent == parent:
                if str(x.conns) != "None":
                    return 'conns: %s' % (str(x.conns))

        return ""

    def get_predictor(self):
        for x in self.predictors:
            if x.name != "None":
                return '[[' + x.name + ']]'
        return ""

    def _getstring(self, level, expand=False):
        tree_list = []
        s = ""
        try:
            if self.children:
                for x in self.children:
                    tree_list.append((self.device_id, x))
                    s += ('    ' * level) + '---' + ('\n' + '    '\
                            * level + '----').\
                            vjoin([" " + str(x.device_id)]) + '\n'
        except:
                s = ""
        if expand:
            s += ''.join([n._getstring(level + 1, True)
                          for n in self.children])
        print tree_list
        return s

    def _getself_html(self):
        return '---' + ('<br />' + '&nbsp;&nbsp;&nbsp;&nbsp;' + \
                '----').join(["&nbsp;" + "%s %s [%s/%s/%s] %s %s %s %s"\
                 % (str(self.device_id), \
                self.alias, self.getSilo(), self.getContext(), self.getType(), self.get_status(self), \
                self.getHostname(), self.getIp(), \
                self.getXenServer())]) + '<br />'

    def flatten(self, x):
        result = []
        for el in x:
            #if isinstance(el, (list, tuple)):
            if hasattr(el, "__iter__") and not isinstance(el, basestring):
                result.extend(self.flatten(el))
            else:
                result.append(el)
        return result

    def _gethtml(self, level, expand=False, leaf=False):
        s = ""
        tree_list = []
        xen_servers_hash = {}
        if self.children:
            for x in self.children:
                tree_list.append(x)
                tree_list.append(x._gethtml(level + 1, leaf=True))
                if not xen_servers_hash.has_key(x.device_id):
                    xen_servers_hash[x.device_id] = x.getXenServer()
                xen_servers_node = xen_servers_hash[x.device_id]
                s += ('&nbsp;&nbsp;&nbsp;&nbsp;' * level) + '---' + \
                        ('<br />' + '&nbsp;&nbsp;&nbsp;&nbsp;' * \
                        level + '----').join(["&nbsp;" + \
                        "%s %s [%s] %s %s %s %s %s" % \
                        (str(x.device_id), x.alias, x.getType(), x.alias, \
                        x.get_status(self), x.getHostname(), x.getIp(), \
                        xen_servers_node)]) + '<br />'
                s += x._gethtml(level + 1)

        print "xen hash", xen_servers_hash
        if leaf:
            return self.flatten(tree_list)
        else:
            return s

    def _isleaf(self):
        if self.children:
            return False
        else:
            return True

    def _gettree(self, level, expand=False, leaf=False):
        try:
            global xen_servers_hash
            s = ""
            if self.children:
                for x in self.children:
                    if not xen_servers_hash.has_key(x.device_id):
                        xen_servers_hash[x.device_id] = x.getXenServer(html=False)
                    xen_servers_node = xen_servers_hash[x.device_id]
                    if x._isleaf():
                        s += ('\n' + '   ' * level) +\
                                "%s [%s] %s %s %s %s %s"\
                                % ( x.alias, x.getType(), \
                                x.get_conns(self), x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                xen_servers_node)
                    else:
                        if x.getType().name != "appvip" and x.getType().name != "sqlvip":
                            if x.getType().name == "rserver" and xen_servers_node:
                                s += ('\n' + '   ' * level ) +\
                                        "%s [%s] %s %s %s %s"\
                                        % ( x.alias, x.getType(), \
                                        x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                        xen_servers_node)
                            elif x.getType().name == "rserver" and x.getIp():
                                s += ('\n' + '   ' * level ) +\
                                        "%s [%s] %s %s %s %s"\
                                        % ( x.alias, x.getType(), \
                                        x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                        xen_servers_node)
                            elif x.getType().name == "rserver":
                                s += ('\n' + '   ' * level ) + \
                                        "%s [%s/%s/%s] %s %s %s %s %s %s"\
                                        % ( x.alias, x.getSilo(), x.getContext(), x.getType(), \
                                        x.get_predictor(), x.get_conns(self), x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                        xen_servers_node)
    
                            else:                                    
                                # Serverfarm
                                s += ('\n' + '   ' * level ) + \
                                        "%s [%s/%s/%s] %s %s %s %s %s %s"\
                                        % ( x.alias, x.getSilo(), x.getContext(), x.getType(), \
                                        x.get_predictor(), x.get_conns(self), x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                        xen_servers_node)
                        else:
                            if x.getType().name == "appvip":
                               s += ('\n' + '   ' * level ) + \
                                       "%s [%s] %s %s %s %s %s"\
                                       % ( x.alias, x.getType(), \
                                       x.get_conns(self), x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                       xen_servers_node)
                            else:           
                               s += ('\n' + '   ' * level ) + \
                                       "%s [%s] %s %s %s %s %s "\
                                       % ( x.alias, x.getType(), \
                                       x.get_conns(self), x.get_status(self,html=False), x.getHostname(), x.getIp(), \
                                       xen_servers_node)
                    s += x._gettree(level + 1)
                s += '   ' * level 
            if leaf:
                return self.flatten(tree_list)
            else:
                return s
        except Exception, err:
            return(str(err))

    def _gethtmltree(self, level, expand=False, leaf=False):
        try:
            global xen_servers_hash
            s = ""
            #tree_list = []
            if self.children:
                if level == 0:
                    s += '   ' * level + '<ul id="browser" class="filetree">'
                else:
                    s += '   ' * level + '<ul>'
                for x in self.children:
                    if not xen_servers_hash.has_key(x.device_id):
                        xen_servers_hash[x.device_id] = x.getXenServer()
                    xen_servers_node = xen_servers_hash[x.device_id]
                    # TODO: Fix buggy code . It generates tons of query to AT
                    #tree_list.append(x)
                    #tree_list.append(x._gethtmltree(level+1, leaf=True))
                    if x._isleaf():
                        s += ('\n' + '   ' * level + '<li><span class="folder">')\
                                + ('').join(['   ' * level + \
                                "%s [%s] %s %s %s %s %s %s %s</span>"\
                                % ( x.alias, x.getType(), \
                                x.get_conns(self), x.get_status(self), x.getHostname(), x.getIp(), \
                                genGGP(x.getHostname()),\
                                genSQL(x.getHostname()), \
                                xen_servers_node), '\n</li></li>'])
                    else:
                        if x.getType().name != "appvip" and x.getType().name != "sqlvip":
                            if x.getType().name == "rserver" and xen_servers_node:
                                s += ('\n' + '   ' * level + '<li><span class="folder">')\
                                        + ('').join(['   ' * level + \
                                        "%s [%s] %s %s %s %s %s %s</span>"\
                                        % ( x.alias, x.getType(), \
                                        x.get_status(self), x.getHostname(), x.getIp(), \
                                        genGGP(x.getHostname()),\
                                        genSQL(x.getHostname()), \
                                        xen_servers_node), '\n'])
                            elif x.getType().name == "rserver" and x.getIp():
                                s += ('\n' + '   ' * level + '<li><span class="folder">')\
                                        + ('').join(['   ' * level + \
                                        "%s [%s] %s %s %s %s %s %s</span>"\
                                        % ( x.alias, x.getType(), \
                                        x.get_status(self), x.getHostname(), x.getIp(), \
                                        genGGP(x.getHostname()),\
                                        genSQL(x.getHostname()), \
                                        xen_servers_node), '\n'])
                            elif x.getType().name == "rserver":
                                s += ('\n' + '   ' * level + '<li><span class="folder">')\
                                        + ('').join(['   ' * level + \
                                        '<font color="#800080">' + \
                                        "%s [%s/%s/%s] %s %s %s %s %s %s </font></span>"\
                                        % ( x.alias, x.getSilo(), x.getContext(), x.getType(), \
                                        x.get_predictor(), x.get_conns(self), x.get_status(self), x.getHostname(), x.getIp(), \
                                        xen_servers_node), '\n'])
    
                            else:                                    
                                # Serverfarm
                                s += ('\n' + '   ' * level + '<li><span class="folder">') \
                                        + ('').join(['   ' * level + \
                                        '<font color="#0000FF">' + \
                                        "%s [%s/%s/%s] %s %s %s %s %s %s </font></span>"\
                                        % ( x.alias, x.getSilo(), x.getContext(), x.getType(), \
                                        x.get_predictor(), x.get_conns(self), x.get_status(self), x.getHostname(), x.getIp(), \
                                        xen_servers_node), '\n'])
                        else:
                            if x.getType().name == "appvip":
                               s += ('\n' + '   ' * level + '<li><span class="folder">') \
                                       + ('').join(['   ' * level + \
                                        '<font color="#FF0080">' + \
                                       "%s [%s] %s %s %s %s %s </font></span>"\
                                       % ( x.alias, x.getType(), \
                                       x.get_conns(self), x.get_status(self), x.getHostname(), x.getIp(), \
                                       xen_servers_node), '\n'])
                            else:           
                               s += ('\n' + '   ' * level + '<li><span class="folder">') \
                                       + ('').join(['   ' * level + \
                                        '<font color="#FFA500">' + \
                                       "%s [%s] %s %s %s %s %s </font></span>"\
                                       % ( x.alias, x.getType(), \
                                       x.get_conns(self), x.get_status(self), x.getHostname(), x.getIp(), \
                                       xen_servers_node), '\n'])
                    s += x._gethtmltree(level + 1)
                s += '   ' * level + '</ul>'
            if leaf:
                return self.flatten(tree_list)
            else:
                return s
        except Exception, err:
            return(str(err))

    def breadth_first(self,children=iter):
        """Traverse the nodes of a tree in breadth-first order.
        The first argument should be the tree root; children
        should be a function taking as argument a tree node and
        returning an iterator of the node's children.
        """
        yield self
        last = self
        for node in self.breadth_first(self.children):
            for child in node.children:
                yield child
                last = child
            if last == node:
                return

    def _getshmuxlist(self, level, data=[]):
        try:
            if self.children:
                for x in self.children:
                    if x.getType().name != "appvip" and x.getType().name != "sqlvip":
                        if x.getType().name == "rserver":
                            if x.getHostname():
                                data.append([x.getHostname(),x.get_status(self,html=False)])
                        else:                                    
                            pass
                    else:
                        pass
                    x._getshmuxlist(level + 1, data) 
            return data
        except Exception, err:
            return(str(err))


    def getType(self):
        return self._types

    def getHostname(self):
        if self.ips:
            for x in self.ips:
                if x.hosts:
                    for y in x.hosts:
                        return y.name
            return ""
        else:
            return ""

    def getContext(self):
        return self._instance

    def getSilo(self):
        return self._silo

    def getIp(self):
        if self.ips:
            for y in self.ips:
                return y.address
        else:
            return ""

    def getXenServer(self,html=True):
        #print 'type', self.getType()
        if self.getType().name == "rserver":
            #print 'getXenServer', self.getType().name, \
            #       self.alias, self.device_id
            current_asset = SessionAT.query(AT_Asset).filter(\
                    AT_Asset.Name == self.getHostname()).first()
            if current_asset != None:
                if current_asset.assoc != None:
                    if current_asset.parent:
                        if current_asset.parent.field_values:
                            last_terminal = ""
                            for term in current_asset.parent.field_values:
                                # 27 is Console
                                if term.CustomField == 27:
                                    ssh_terminal = term.Content
                                    if "ssh" in ssh_terminal:
                                        last_terminal = "Terminal Login: %s"\
                                                % ssh_terminal
                            if html:
                                return "<ul><li>[%s] %s %s %s" % (\
                                    current_asset.parent.get_Type(), \
                                    current_asset. \
                                    parent.get_Name(), \
                                    current_asset.parent.get_Status(), \
                                    last_terminal) + '</li></ul>'
                            else:
                                return "[%s] %s %s %s" % (\
                                    current_asset.parent.get_Type(), \
                                    current_asset. \
                                    parent.get_Name(), \
                                    current_asset.parent.get_Status(), \
                                    last_terminal)
            SessionAT.close()
            return ""
        else:
            SessionAT.close()
            return ""


class Ipmap(object):
    pass


class Predictor(object):
    pass

class Description(object):
    pass

class Device_to_Detail(object):
    pass

class Interface_to_Detail(object):
    pass

class APP_to_SQL(object):
    pass


class PXY_to_APP(object):
    pass

type = Table('type', dbmetadata,
    Column('type_id', Integer, primary_key=True),
    Column('name', String(50)),
)

silo = Table('silo', dbmetadata,
    Column('silo_id', Integer, primary_key=True),
    Column('name', String(50)),
)

instance = Table('instance', dbmetadata,
    Column('instance_id', Integer, primary_key=True),
    Column('name', String(50)),
)

ip = Table('ip', dbmetadata,
    Column('ip_id', Integer, primary_key=True),
    Column('address', String(20), unique=True))


ip_map = Table('ip_map', dbmetadata,
    Column('in_ip', String(20), primary_key=True),
    Column('out_ip', String(20)),
)

device = Table('device', dbmetadata,
    Column('device_id', Integer, primary_key=True),
    Column('types', Integer, ForeignKey('type.type_id')),
    Column('silo', Integer, ForeignKey('silo.silo_id')),
    Column('instance', Integer, ForeignKey('instance.instance_id')),
    Column('alias', String(50)),
    Column('status', Integer))

description = Table('description', dbmetadata,
    Column('description_id', Integer, primary_key=True),
    Column('device_id', Integer, ForeignKey('device.device_id')),
    Column('name', String(50)),
)
#Add M to N relationship between device and predictor
device_predictor = Table('device_predictor', dbmetadata,
    Column('device_id', Integer, \
            ForeignKey('device.device_id'), primary_key=True),
    Column('predictor_id', Integer, \
            ForeignKey('predictor.predictor_id'), primary_key=True),
)
#Add LB predictor field
predictor = Table('predictor', dbmetadata,
    Column('predictor_id', Integer, primary_key=True),
    Column('name', String(30)),
)
#Add Generic Detail
detail = Table('detail', dbmetadata,
    Column('detail_id', Integer, primary_key=True),
    Column('name', String(40)),
    Column('parameters', String(60)),
)

device_to_details = Table('device_to_details', dbmetadata,
    Column('id', Integer, primary_key=True),
    Column('device_id', Integer, ForeignKey('device.device_id')),
    Column('detail_id', Integer, ForeignKey('detail.detail_id')),
)

#Add Interface
interface = Table('interface', dbmetadata,
    Column('interface_id', Integer, primary_key=True),
    Column('silo', Integer, ForeignKey('silo.silo_id')),
    Column('instance', Integer, ForeignKey('instance.instance_id')),
    Column('alias', String(50)),
    Column('status', Integer))

#Interface to Detail

interface_to_details = Table('interface_to_details', dbmetadata,
    Column('id', Integer, primary_key=True),
    Column('interface_id', Integer, ForeignKey('interface.interface_id')),
    Column('detail_id', Integer, ForeignKey('detail.detail_id')),
)

#Add VLan
vlan = Table('vlan', dbmetadata,
    Column('vlan_id', Integer, primary_key=True),
    Column('name', String(20)),
    Column('ip', String(20)),
    Column('netmask', Integer),
    )

#Add Vertical
vertical = Table('vertical', dbmetadata,
    Column('vertical_id', Integer, primary_key=True),
    Column('name', String(20)),
)

#Add Business Owner
business_owner = Table('business_owner', dbmetadata,
    Column('business_owner_id', Integer, primary_key=True),
    Column('name', String(20)),
    Column('short', String(20)),
)

#Add Environment
environment = Table('environment', dbmetadata,
    Column('environment_id', Integer, primary_key=True),
    Column('name', String(20)),
)

#Define tree Table
example_tree = Table('tree', dbmetadata,
    Column('id', Integer, primary_key=True),
    Column('parent_id', Integer, ForeignKey('device.device_id')),
    Column('child_id', Integer, ForeignKey('device.device_id')),
    Column('depth', Integer),
    Column('length', Integer),
    Column('conns', Integer),
    Column('status', Integer),
)

ip_to_device = Table('ip_to_device', dbmetadata,
    Column('ip_id', Integer, ForeignKey('ip.ip_id')),
    Column('device_id', Integer, ForeignKey('device.device_id')),
)

map_model(Device, device, example_tree)

host = Table('host', dbmetadata,
    Column('host_id', Integer, primary_key=True),
    Column('name', String(50)),
)

ip_to_host = Table('ip_to_host', dbmetadata,
    Column('ip_id', Integer, ForeignKey('ip.ip_id')),
    Column('host_id', Integer, ForeignKey('host.host_id')),
)

app_to_sql = Table('app_to_sql', dbmetadata,
    Column('id', Integer, primary_key=True),
    Column('app_ip', String(20)),
    Column('sql_ip', String(20)),
    Column('conns', Integer),
    Column('date_inserted', DateTime),
)

pxy_to_app = Table('pxy_to_app', dbmetadata,
    Column('id', Integer, primary_key=True),
    Column('pxy_ip', String(20)),
    Column('app_ip', String(20)),
    Column('conns', Integer),
    Column('date_inserted', DateTime),
)

revision = Table('revision', dbmetadata,
    Column('id', Integer, primary_key=True),
    Column('source', String(20)),
    Column('revision', Integer),
    Column('date_inserted', DateTime),
)

dbmetadata.create_all()

mapper(Revision, revision)
mapper(APP_to_SQL, app_to_sql)
mapper(PXY_to_APP, pxy_to_app)
mapper(IP, ip)
mapper(Types, type)
mapper(Silo, silo)
mapper(Description, description)
mapper(Instance, instance)
mapper(Predictor, predictor)
mapper(Detail, detail)
mapper(Vlan, vlan)
mapper(Vertical, vertical)
mapper(Business_Owner, business_owner)
mapper(Environment, environment)
mapper(Host, host, properties={
    'ips': relation(IP, secondary=ip_to_host, backref='hosts'),
})
mapper(Interface, interface, properties={
    'details': relation(Detail, secondary=interface_to_details, backref='interface'),
    '_silo': relation(Silo),
    '_instance': relation(Instance),
})
# Add LB Predictor

mapper(Ipmap, ip_map)
