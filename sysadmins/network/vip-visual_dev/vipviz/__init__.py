#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.config import Configurator
from sqlalchemy import engine_from_config

from .models import initializeSQL

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')

    initializeSQL(engine)

    config = Configurator(settings=settings)
    config.add_static_view('static', 'static', cache_max_age=3600)
    #config.add_route('home', '/')
    #config.add_route('query', '/query')
    config.add_route('query', '/')
    config.add_route('ip_lookup', '/iplookup')
    config.add_route('extract_server', '/extract_server')
    config.scan()
    return config.make_wsgi_app()

