#!/usr/bin/python
# -*- coding: utf-8 -*-
from sqlalchemy import *
from sqlalchemy.orm import *
from sqlalchemy.ext.associationproxy import association_proxy

db_locale = create_engine('mysql://vip_inven:KrTzXDcN@vip-sqlrw-inv.tp.prd.lax.gnmedia.net:3306/rt3?use_unicode=1&charset=utf8',pool_size = 100, pool_recycle=7200, echo=False)
dbmetadata_locale = MetaData()
dbmetadata_locale.bind = db_locale

class AT_IP(object):
    pass
        
class AT_Asset(object):
    def get_Type(self):
      return self.asset_type.Name
    def get_Name(self):
      return self.Name
    def get_Description(self):
      return self.Description
    def get_Status(self):
      return self.Status
    def get_URI(self):
      return self.URL
    def get_LastUpdatedBy(self):
      return self.LastUpdatedBy
    def get_Creator(self):
      return self.Creator
    def get_Created(self):
      return self.Created
    

class AT_Types(object):
    pass

class Custom_Fields(object):
    pass

class Custom_Field_Values(object):
    pass

class Object_Custom_Fields(object):
    pass

class Object_Custom_Field_Values(object):
    pass
'''
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| Type          | int(11)      | NO   | MUL | 0       |                |FK
| Name          | varchar(200) | NO   | MUL | NULL    |                |
| Description   | varchar(255) | YES  |     | NULL    |                |
| Status        | varchar(20)  | YES  |     | NULL    |                |
| URI           | varchar(255) | YES  |     | NULL    |                |
| LastUpdatedBy | int(11)      | NO   |     | 0       |                |
| LastUpdated   | datetime     | YES  |     | NULL    |                |
| Creator       | int(11)      | NO   |     | 0       |                |
| Created     
'''


'''
mysql> describe AT_Types;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| Name          | varchar(200) | NO   | UNI | NULL    |                |
| Description   | varchar(255) | YES  |     | NULL    |                |
| DefaultAdmin  | int(11)      | YES  |     | 0       |                |
| Creator       | int(11)      | NO   |     | 0       |                |
| Created       | datetime     | YES  |     | NULL    |                |
| LastUpdatedBy | int(11)      | NO   |     | 0       |                |
| LastUpdated   | datetime     | YES  |     | NULL    |                |
| Disabled      | smallint(6)  | NO   | MUL | 0       |                |
+---------------+--------------+------+-----+---------+----------------+
'''

'''
mysql> describe Links;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| Base          | varchar(240) | YES  | MUL | NULL    |                |
| Target        | varchar(240) | YES  | MUL | NULL    |                |
| Type          | varchar(20)  | NO   | MUL | NULL    |                |
| LocalTarget   | int(11)      | NO   |     | 0       |                |
| LocalBase     | int(11)      | NO   |     | 0       |                |
| LastUpdatedBy | int(11)      | NO   |     | 0       |                |
| LastUpdated   | datetime     | YES  |     | NULL    |                |
| Creator       | int(11)      | NO   |     | 0       |                |
| Created       | datetime     | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+
'''

'''
mysql> describe CustomFields;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| Name          | varchar(200) | YES  |     | NULL    |                |
| Type          | varchar(200) | YES  |     | NULL    |                |
| MaxValues     | int(11)      | YES  |     | NULL    |                |
| Pattern       | varchar(255) | YES  |     | NULL    |                |
| Repeated      | smallint(6)  | NO   |     | 0       |                |
| Description   | varchar(255) | YES  |     | NULL    |                |
| SortOrder     | int(11)      | NO   |     | 0       |                |
| LookupType    | varchar(255) | NO   |     | NULL    |                |
| Creator       | int(11)      | NO   |     | 0       |                |
| Created       | datetime     | YES  |     | NULL    |                |
| LastUpdatedBy | int(11)      | NO   |     | 0       |                |
| LastUpdated   | datetime     | YES  |     | NULL    |                |
| Disabled      | smallint(6)  | NO   |     | 0       |                |
+---------------+--------------+------+-----+---------+----------------+
'''

'''
mysql> describe CustomFieldValues;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| CustomField   | int(11)      | NO   | MUL | NULL    |                |
| Name          | varchar(200) | YES  |     | NULL    |                |
| Description   | varchar(255) | YES  |     | NULL    |                |
| SortOrder     | int(11)      | NO   |     | 0       |                |
| Creator       | int(11)      | NO   |     | 0       |                |
| Created       | datetime     | YES  |     | NULL    |                |
| LastUpdatedBy | int(11)      | NO   |     | 0       |                |
| LastUpdated   | datetime     | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

mysql> describe ObjectCustomFields;
+---------------+----------+------+-----+---------+----------------+
| Field         | Type     | Null | Key | Default | Extra          |
+---------------+----------+------+-----+---------+----------------+
| id            | int(11)  | NO   | PRI | NULL    | auto_increment |
| CustomField   | int(11)  | NO   |     | NULL    |                |
| ObjectId      | int(11)  | NO   |     | NULL    |                |
| SortOrder     | int(11)  | NO   |     | 0       |                |
| Creator       | int(11)  | NO   |     | 0       |                |
| Created       | datetime | YES  |     | NULL    |                |
| LastUpdatedBy | int(11)  | NO   |     | 0       |                |
| LastUpdated   | datetime | YES  |     | NULL    |                |
+---------------+----------+------+-----+---------+----------------+

mysql> describe ObjectCustomFieldValues
    -> ;
+-----------------+--------------+------+-----+---------+----------------+
| Field           | Type         | Null | Key | Default | Extra          |
+-----------------+--------------+------+-----+---------+----------------+
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| CustomField     | int(11)      | NO   | MUL | NULL    |                |
| ObjectType      | varchar(255) | NO   |     | NULL    |                |
| ObjectId        | int(11)      | NO   |     | NULL    |                |
| SortOrder       | int(11)      | NO   |     | 0       |                |
| Content         | varchar(255) | YES  | MUL | NULL    |                |
| LargeContent    | longtext     | YES  |     | NULL    |                |
| ContentType     | varchar(80)  | YES  |     | NULL    |                |
| ContentEncoding | varchar(80)  | YES  |     | NULL    |                |
| Creator         | int(11)      | NO   |     | 0       |                |
| Created         | datetime     | YES  |     | NULL    |                |
| LastUpdatedBy   | int(11)      | NO   |     | 0       |                |
| LastUpdated     | datetime     | YES  |     | NULL    |                |
| Disabled        | smallint(6)  | NO   |     | 0       |                |
+-----------------+--------------+------+-----+---------+----------------+

'''

def map_model(Node, node_table, tree_table):
    class SetupDepth(MapperExtension):
        def before_insert(self, mapper, connection, instance):
            parent = instance.parent
            if parent and parent.assoc:
                instance.depth = parent.assoc.depth + 1
            else:
                instance.depth = 0
            child = instance.node
            instance.length = child
            
    # Declar TreeAssoc

    class TreeAssoc(object):
        def __init__(self, node, parent):
            self.node = node
            self.parent = parent
            self.depth = 0
            self.length = 0
            
    #http://markmail.org/message/jyh6zebrkgdxdczq#query:+page:1+mid:vzqmibpxmqfqzy5s+state:results
    mapper(TreeAssoc, tree_table, properties={
        'node':relation(Node, backref=backref('assoc', uselist=False), primaryjoin=node_table.c.id==tree_table.c.LocalBase)
    }, extension=SetupDepth())
    
    # ***** TO use Reversed Sort order_by has to be added here ******
    # Also the sorting mechanism table has to be added to the tree
    mapper(Node, node_table, properties={
        '_children':relation(TreeAssoc, backref='parent',primaryjoin=node_table.c.id==tree_table.c.LocalTarget)
    })

    Node.children = association_proxy('_children', 'node', creator=lambda n: TreeAssoc(n, None))
    Node.parent = association_proxy('assoc', 'parent', creator=lambda n: TreeAssoc(None, n))
    
    #http://www.mail-archive.com/sqlalchemy@googlegroups.com/msg03329.html
    def depth(self):
        if self.assoc:
            return self.assoc.depth
        else:
            return 0
    Node.depth = property(depth)


at_types = Table('AT_Types', dbmetadata_locale,
                Column('id', Integer, primary_key=True),
                        autoload=True)

at_ip = Table('AT_IPs', dbmetadata_locale, 
                Column('id', Integer, primary_key=True),
                        autoload=True)

at_asset = Table('AT_Assets', dbmetadata_locale, 
                Column('id', Integer, primary_key=True),
                Column('Type', Integer, ForeignKey('AT_Types.id')),
                        autoload=True)

custom_field = Table('CustomFields', dbmetadata_locale, 
                Column('id', Integer, primary_key=True),
                        autoload=True)

custom_field_value = Table('CustomFieldValues', dbmetadata_locale, 
                Column('id', Integer, primary_key=True),
                Column('CustomField', Integer, ForeignKey('CustomFields.id')),
                        autoload=True)

object_custom_field = Table('ObjectCustomFields', dbmetadata_locale, 
                Column('id', Integer, primary_key=True),
                Column('CustomField', Integer, ForeignKey('CustomFields.id')),
                Column('ObjectId', Integer, ForeignKey('AT_Assets.id')),
                        autoload=True)

object_custom_field_value = Table('ObjectCustomFieldValues', dbmetadata_locale, 
                Column('id', Integer, primary_key=True),
                Column('CustomField', Integer, ForeignKey('CustomFields.id')),
                Column('ObjectId', Integer, ForeignKey('AT_Assets.id')),
                        autoload=True)

link = Table('Links', dbmetadata_locale,
                Column('id', Integer, primary_key=True),
                Column('LocalTarget',Integer,ForeignKey('AT_Assets.id')),
                Column('LocalBase',Integer,ForeignKey('AT_Assets.id')),
                        autoload=True)
                
mapper(AT_IP, at_ip)
mapper(Custom_Fields, custom_field)
mapper(Custom_Field_Values, custom_field_value)
mapper(Object_Custom_Fields, object_custom_field)
mapper(Object_Custom_Field_Values, object_custom_field_value, properties={
         'asset':relation(AT_Asset,backref='field_values') }
)
map_model(AT_Asset, at_asset, link)

mapper(AT_Types,at_types, properties = {
    'assets':relation(AT_Asset,backref='asset_type')
}
)

if __name__ == "__main__":
    Session = sessionmaker()
    session = Session()
    p1 = session.query(AT_Asset).all()
    for x in p1:
      print "%s -- %s -- %s"%(x.get_Type(),x.get_Name(),x.get_Status())
      ssh_terminal = ''
      if x.field_values:
          for z in x.field_values:
               # 27 is Console
               if z.CustomField == 27:
                   ssh_terminal = z.Content
                   #print z.Content
          print ssh_terminal
      for y in x.children:
          print "   --- %s -- %s -- %s"%(y.get_Type(),y.get_Name(),y.get_Status())
    pass
