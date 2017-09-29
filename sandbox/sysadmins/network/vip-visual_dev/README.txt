VipViz README
==================

Setting-up the Environment

- python-develop
- python-setuptools
- python-virtualenv (From EPEL)

Required Packages:

- gcc
- adns
- adns-devel
- mysql-devel
- graphviz

Required Python Packages

- MySQL-python
- pydot

Getting Started
---------------

- cd <directory containing this file>

- $venv/bin/python setup.py develop

- $venv/bin/populate_VipViz development.ini

- $venv/bin/pserve development.ini

