#!/usr/bin/python
# -*- coding: utf-8 -*-

from sqlalchemy import *
from sqlalchemy.orm import *
from sqlalchemy.ext.associationproxy import association_proxy

import sys
import datetime
from lib.unicode_csv import *
import cidr

def uni_utf8(data):
    # check if the input is unicode
    if type(data) == type(u''):
       return data.encode('utf-8')
    return data

def search_map_model(Node, node_table, search_tree_table):
    # This is used to setup an instance before that instance is inserted into its table
    # This case it specifies the search_TreeAssoc Object
    class SetupDepth(MapperExtension):
        def before_insert(self, mapper, connection, instance):
            parent = instance.parent
            # If instance.parent (Current Inserting Node) is valid
            # parent.assoc means node.assoc (to search_TreeAssoc)
            # If has parent and parent node has assoc (search_TreeAssoc)
            if parent and parent.assoc:
                instance.depth = parent.assoc.depth + 1
            else:
                instance.depth = 0
            # Setup Instance
            child = instance.node
            
    # Declar search_TreeAssoc

    class search_TreeAssoc(object):
        def __init__(self, node, parent):
            self.node = node
            self.parent = parent
            self.depth = 0
            
    mapper(search_TreeAssoc, search_tree_table, properties={
        'node':relation(Node, backref=backref('assoc', uselist=False), primaryjoin=node_table.c.id==search_tree_table.c.child_id)
    }, extension=SetupDepth())
    
    mapper(Node, node_table, properties={
        '_children':relation(search_TreeAssoc, backref='parent', primaryjoin=node_table.c.id==search_tree_table.c.parent_id, collection_class=set)
    })

    Node.children = association_proxy('_children', 'node', creator=lambda n: search_TreeAssoc(n, None))
    Node.parent = association_proxy('assoc', 'parent', creator=lambda n: search_TreeAssoc(None, n))
    
    def depth(self):
        if self.assoc:
            return self.assoc.depth
        else:
            return 0
    Node.depth = property(depth)

def get_vlan(ip):
    f = open('/app/shared/vipvisual/sqlhostname', 'r')
    sqlhostname=f.readline()
    f.close()
    f = open('/app/shared/vipvisual/sqlpassword', 'r')
    sqlpassword=f.readline()
    f.close()

    engine = create_engine('mysql://vipvisual:'+sqlpassword+'@'+sqlhostname+':3306/servers_buff?\
use_unicode=1&charset=utf8', pool_size=100, \
        pool_recycle=7200)
    metadata = MetaData()
    metadata.bind = engine
    Session = sessionmaker(bind=engine)()

    class Node(object):

        def __init__(self, octal, vlan = None, parent = None):
            self.octal = octal
            self.vlan = vlan
            self.parent = parent

        '''
        def __repr__(self):
            return ", ".join(map(uni_utf8,(self.name , unicode(self.name_en) , unicode(self.zipcode))))
        def __repr__(self):
            return uni_utf8(self.name)
        '''


    #Define nodes table
    example_node_table = Table('search_nodes', metadata,
        Column('id', Integer, primary_key=True),
        Column('octal', String(50)),
        Column('vlan', String(10)),
    )

    #Define tree Table
    example_tree_table = Table('search_tree', metadata,
        Column('id', Integer, primary_key=True),
        Column('parent_id', Integer, ForeignKey('search_nodes.id')),
        Column('child_id', Integer, ForeignKey('search_nodes.id')),
        Column('depth', Integer),
    )
    metadata.create_all(engine)
    search_map_model(Node, example_node_table, example_tree_table)

    RootNode = Session.query(Node).filter_by(id=1).first()
    CurrentNode = RootNode
       
    sp_ip = ip.split('.')
    #print sp_ip
    for lvl1 in CurrentNode.children:
        if sp_ip[0] == lvl1.octal:
            #print lvl1.octal
            for lvl2 in lvl1.children:
                if sp_ip[1] == lvl2.octal:
                    #print lvl2.octal
                    for lvl3 in lvl2.children:
                        if sp_ip[2] == lvl3.octal:
                            #print lvl3.octal
                            for lvl4 in lvl3.children:
                                if sp_ip[3] == lvl4.octal:
                                    #print lvl4.octal
                                    return lvl4.vlan

if __name__ == '__main__':
    # This part is to read the address information
    infilecsv = open(sys.argv[1],'r')
    reader = UnicodeReader(infilecsv,delimiter=',', quotechar='\"',quoting=csv.QUOTE_ALL,encoding ='utf-8' )

    f = open('/app/shared/vipvisual/sqlhostname', 'r')
    sqlhostname=f.readline()
    f.close()
    f = open('/app/shared/vipvisual/sqlpassword', 'r')
    sqlpassword=f.readline()
    f.close()

    #engine = create_engine('sqlite:///:memory:', echo=True)
    #engine = create_engine('sqlite:///:memory:', echo=False)
    #engine = create_engine('mysql://roger:dit-admin@dell/address?use_unicode=1&charset=utf8', echo=False)
    engine = create_engine('mysql://vipvisual:$sqlpassword@$sqlhostname:3306/servers_buff?\
use_unicode=1&charset=utf8', pool_size=100, \
        pool_recycle=7200)
    metadata = MetaData()
    metadata.bind = engine
    Session = sessionmaker(bind=engine)()

    class Node(object):

        def __init__(self, octal, vlan = None, parent = None):
            self.octal = octal
            self.vlan = vlan
            self.parent = parent

        '''
        def __repr__(self):
            return ", ".join(map(uni_utf8,(self.name , unicode(self.name_en) , unicode(self.zipcode))))
        def __repr__(self):
            return uni_utf8(self.name)
        '''


    #Define nodes table
    example_node_table = Table('search_nodes', metadata,
        Column('id', Integer, primary_key=True),
        Column('octal', String(50)),
        Column('vlan', String(10)),
    )

    #Define tree Table
    example_search_tree_table = Table('search_tree', metadata,
        Column('id', Integer, primary_key=True),
        Column('parent_id', Integer, ForeignKey('search_nodes.id')),
        Column('child_id', Integer, ForeignKey('search_nodes.id')),
        Column('depth', Integer),
    )
    metadata.create_all(engine)
    search_map_model(Node, example_node_table, example_search_tree_table)

    RootNode = Node('0')
    CurrentNode = RootNode
    for r in reader:
       vlan = r[0]
       ip_range = cidr.getCIDR(r[1])
       for ip in ip_range:
           print ip,vlan
           ip_split = ip.split('.')
           # 4 levels search
           record = [vlan] + ip_split
           print 'record',record
           # Start Building Tree
           # If only 1 element (meaning the last leaf postfix)
           for idx, element in enumerate(record[1:]):
               print ':::::', idx, element
               if idx == 3:
                   print '-------------element[0]-----------------------', vlan
                   CurrentNode = Node(element,vlan,parent=CurrentNode)
               else:
                      inChildren = False
                      # if this element is in the Children (For instance: Root.Children)
                      # This is the bottleneck of the problem
                      # TODO: Find a better way to check the set
                      for x in CurrentNode.children:
                          if element == x.octal:
                              CurrentNode = x
                              inChildren = True
                      if not inChildren:
                              CurrentNode = Node(element, parent=CurrentNode)
           CurrentNode = RootNode
       
    # EOF Parsing
    print RootNode
    print RootNode.children
    
    Session.add(RootNode)
    Session.commit()
    #print n1
    '''
    assert n1.depth == 0
    assert n2.depth == 1
    assert n4.depth == 2

    assert n1.children == set([n2, n3])
    assert n4.parent is n2
    '''
