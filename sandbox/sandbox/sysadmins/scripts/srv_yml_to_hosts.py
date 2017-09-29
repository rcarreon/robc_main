import yaml
from os.path import expanduser

stream = open(expanduser("~/Documents/peak.srv.yml"), "r")
docs = yaml.load_all(stream)

# only one doc, metalhosts
for doc in docs:
    # only need iterate values in metalhosts
        # servername: srv.thing
        #  prod: ##this is an ip
    for srv_rec in doc.itervalues():
        # for k,v in srv.items():
        #     print k, "->", v
        for name,data in srv_rec.items():
            print data['Prod'] + ' ' + name
        print "\n",