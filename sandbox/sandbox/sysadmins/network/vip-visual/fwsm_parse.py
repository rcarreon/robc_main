#!/usr/bin/python
from ciscoconfparse import *
from lib.multiple_replace import multiple_replace

from Model_Buff import *
import sys

Session = sessionmaker(bind=db)()  

name_str = r"""name (.*?) (.*?)$"""
name_rx = re.compile(name_str)
static_str = r"""static \(.*?\) (.*?) (.*?) .*$"""
static_rx = re.compile(static_str)

def send_mail(content,subject,send_to):
    MAIL = "/bin/mailx"
    pp = os.popen("%s -s \"%s\" \"%s\"" % (MAIL, subject, send_to),"w")
    result = "Hi,\nSomething went wrong during parsing fwsm rancid config:\n\n" + content
    pp.write(result)
    exitcode = pp.close()
    if exitcode:
        return "Exit code is %s" % exitcode

SILO,SERVERFARM = ('5',2)
def loadconf(filename):
    try:
        parse = CiscoConfParse(filename)
        name_conf = parse.find_all_children("^name")
        name_lines = CiscoConfParse(name_conf).find_lines("^name")
    
        name_ip = dict()
        name_ip["1.1.1.1"]="dummy"
        # Build Name-IP Dictionary
        for name_line in name_lines:
            m = name_rx.search(name_line)
            if m != None:
               name_ip[m.group(2)] = m.group(1) 
        print name_ip
        
        static_conf = parse.find_all_children("^static")
        static_lines = CiscoConfParse(static_conf).find_lines("^static")
        for s_line in static_lines:
            map_node = Ipmap()
            m = static_rx.search(s_line)
            if m != None:
                map_node.in_ip = m.group(1)
                map_node.out_ip = m.group(2)
                print map_node.in_ip, " -> ", map_node.out_ip
                found=Session.query(Ipmap).filter(Ipmap.in_ip==map_node.in_ip).first()
                if found:
                    Session.delete(found)
                print "Adding node... "+map_node.in_ip
                Session.add(map_node)
        Session.commit()
    except Exception, err:
        send_mail(str(err), "WARNING: Vipvisual fwsm parsing error", "sysadmins@gorillanation.com" )
        print str(err)
        sys.exit()

if __name__ == '__main__':
    loadconf("configs/fwsm1.core1.gnmedia.net")
