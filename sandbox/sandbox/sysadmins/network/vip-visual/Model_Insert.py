#!/usr/bin/python
# -*- coding: utf-8 -*-
from sqlalchemy import *
from sqlalchemy.orm import *
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.orm.collections import attribute_mapped_collection
from sqlalchemy.sql import func

from Cheetah.Template import Template
from datetime import datetime, timedelta

f = open('/app/shared/vipvisual/sqlhostname', 'r')
sqlhostname=f.readline()
f.close()
f = open('/app/shared/vipvisual/sqlpassword', 'r')
sqlpassword=f.readline()
f.close()

db_buff = create_engine('mysql://vipvisual:'+sqlpassword+'@'+sqlhostname+':3306/servers_buff?\
use_unicode=1&charset=utf8', pool_size=100, \
        pool_recycle=7200)
dbmetadata_buff = MetaData()
dbmetadata_buff.bind = db_buff

class APP_to_SQL_buff(object):
    pass


class PXY_to_APP_buff(object):
    pass

app_to_sql_buff = Table('app_to_sql', dbmetadata_buff,
    Column('id', Integer, primary_key=True),
    Column('app_ip', String(20)),
    Column('sql_ip', String(20)),
    Column('conns', Integer),
    Column('date_inserted', DateTime),
)

pxy_to_app_buff = Table('pxy_to_app', dbmetadata_buff,
    Column('id', Integer, primary_key=True),
    Column('pxy_ip', String(20)),
    Column('app_ip', String(20)),
    Column('conns', Integer),
    Column('date_inserted', DateTime),
)

dbmetadata_buff.create_all()

mapper(APP_to_SQL_buff, app_to_sql_buff)
mapper(PXY_to_APP_buff, pxy_to_app_buff)
