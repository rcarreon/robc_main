from paste.deploy.loadwsgi import appconfig
config = appconfig('config:/app/shared/venv26/vipviz/development.ini', 'main', relative_to='.')
print config['svn_directory']
