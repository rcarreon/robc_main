#!/usr/bin/python
import dns.zone
from dns.exception import DNSException
from dns.rdataclass import *
from dns.rdatatype import *
from ciscoconfparse import *
import sys

from Model_Buff import *

Session = sessionmaker(bind=db)()

rserver_str = r"""^rserver host (.*?)$"""
rserver_rx = re.compile(rserver_str)
filename_str = r"""^configs/(.*?)\."""
filename_rx = re.compile(filename_str)
ip_address_str = r"""ip address (.*?)$"""
ip_address_rx = re.compile(ip_address_str)
serverfarm_str = r"""^    (serverfarm|sticky-serverfarm) (.*?)( |$)"""
serverfarm_rx = re.compile(serverfarm_str)
sec_serverfarm_str = r"""^  (serverfarm|sticky-serverfarm) (.*?)( |$)"""
sec_serverfarm_rx = re.compile(sec_serverfarm_str)
serverfarm_rserver_str = r"""^  rserver (.*?)$"""
serverfarm_rserver_rx = re.compile(serverfarm_rserver_str)
sticky_str = r"""^sticky .* (.*?)$"""
sticky_rx = re.compile(sticky_str)
virtual_address_str = r"""  [0-9] match virtual-address (.*?) tcp eq (.*?)$"""
virtual_address_str_rx = re.compile(virtual_address_str)
digit_str = r""" (\d+)"""
digit_rx = re.compile(digit_str)

SILO, SERVERFARM = ('4', 2)

def send_mail(content,subject,send_to):
    MAIL = "/bin/mailx"
    pp = os.popen("%s \"%s\" -s \"%s\" -v" % (MAIL, send_to, subject),"w")
    result = "Hi,\nSomething went wrong during parsing lax3 rancid config:\n\n" + content
    pp.write(result)
    exitcode = pp.close()
    if exitcode:
        return "Exit code is %s" % exitcode

def loadconf(filename):
    try:
        parse = CiscoConfParse(filename)
        # Start parsing VIP lines
        # Try to pull out all rservers IP first
        rserver_conf = parse.find_all_children("^rserver")
        rserver_lines = CiscoConfParse(rserver_conf).find_lines("^rserver")
        status = 0
        silo_node = Session.query(Silo).filter_by(silo_id=SILO).first()
        m = instance = filename_rx.search(filename)
        instance_node = Session.query(Instance).filter_by(name=m.group(1)).first()
    
        for x in rserver_lines:
            print x
            # get single rserver config
            single_rserver_conf = CiscoConfParse(\
                    rserver_conf).find_all_children(x, exactmatch=True)
            node = Device()
            node.alias = x.replace('rserver host ', '')
            # check ip and inservice
            print single_rserver_conf
            for y in single_rserver_conf:
                m = ip_address_rx.search(y)
                if m != None:
                    print 'IP', m.group(1)
                    # HERE we link ip to host
                    ip_node = Session.query(IP).filter_by(\
                            address=m.group(1)).first()
                    if ip_node == None:
                        db_ip = IP()
                        db_ip.address = m.group(1)
                    else:
                        db_ip = ip_node
                    node.ips.append(db_ip)
                else:
                    if "inservice" in y:
                        node.status = 1
            # Assign rserver type to the node
            type_node = Session.query(Types).filter_by(name="rserver").first()
            node._types = type_node
            node._silo = silo_node
            node._instance = instance_node
            Session.add(node)
        Session.commit()
        result = Session.query(Device).all()
        #EOF adding all of the rserver nodes
    
        for x in result:
            for y in x.ips:
                if x._types != None:
                    print "%s, %s, %s, %s" % (\
                        y.address, x.alias, x.status, x._types.name)
                else:
                    print "TYPE ERROR: %s, %s" % (y.address, x.alias)
    
        serverfarm_conf = parse.find_all_children("^serverfarm host")
        # get serverfarm lines
        serverfarm_lines = CiscoConfParse(\
                serverfarm_conf).find_lines("^serverfarm host")
        # get sticky serverfarm lines
        sticky_serverfarm_conf = parse.find_all_children("^sticky")
        sticky_serverfarm_lines = CiscoConfParse(\
                sticky_serverfarm_conf).find_lines("^sticky")
        # get all serverfarm config
        for x in serverfarm_lines:
            serverfarm = x.replace('serverfarm host ', '')
            # Specify Type
            type_node = Session.query(Types).filter_by(name="serverfarm").first()
            group_node = Device()
            # create node with the name of the serverfarm
            group_node.alias = serverfarm
            group_node._types = type_node
            group_node._silo = silo_node
            group_node._instance = instance_node
            # Fix flush
            Session.add(group_node)
            Session.commit()
            # get single serverfarm config
            single_serverfarm_conf = CiscoConfParse(\
                    serverfarm_conf).find_all_children(x, exactmatch=True)
            # find all rserver in the serverfarm
            rserver_lines = CiscoConfParse(\
                    single_serverfarm_conf).find_lines("rserver")
            # build the tree
            for y in rserver_lines:
                # Here we need to consider the port number
                # Todo: RegEX on the port number
                alias_name = y.replace('  rserver ', '').replace(' 8080', '')
                device_node = Session.query(Device).filter_by(\
                        alias=alias_name).filter(Device.silo == SILO).first()
                # If we can't find the Node in our device,
                # it means that there is a problem with the setup
                print "---- GROUP NODE:", group_node.alias, group_node.device_id
                print "---------- DEVICE NODE:", device_node
                if device_node != None:
                    print "---------------- DEVICE DETAIL:", \
                            device_node.device_id, device_node.types, \
                            device_node.ips, device_node.alias
    
                if device_node == None:
                    print "Error:"
                    print 'Alias_name is ', alias_name
                    continue
                else:
                    # create assoc tree
                    current_assoc = TreeAssoc(device_node, group_node)
                    Session.commit()
                    print 'GN', group_node.alias
                    for x in device_node.parent:
                        print x.alias
                    # x is tree_Assoc
                    for x in group_node._children:
                        print x.id
                        print x.parent_id
                        print x.child_id
                        print x.node.alias
                single_rserver_conf = CiscoConfParse(\
                        single_serverfarm_conf).find_all_children(\
                        y, exactmatch=True)
                print single_rserver_conf
                # rserver found
                for z in single_rserver_conf:
                    if ("inservice" in z):
                        current_assoc.status = 1
                    else:
                        current_assoc.status = 0
    
            predictor_lines = CiscoConfParse(\
                    single_serverfarm_conf).find_lines("predictor")
            print predictor_lines
            if len(predictor_lines):
                for z in predictor_lines:
                    predictor_node = Session.query(Predictor).filter_by(\
                            name=z.replace('  predictor ', '')).first()
                    if predictor_node == None:
                        print "Predictor doesn't exist!"
                    else:
                        group_node.predictors.append(predictor_node)
            else:
                predictor_node = Session.query(Predictor).filter_by(\
                        name="roundrobin").first()
                group_node.predictors.append(predictor_node)
        # Start creating the links between group and device
        # Get VIP Configuration
        class_conf = parse.find_all_children("^class-map match-")
        # Get all L4 policy map
        L4_lines = CiscoConfParse(class_conf).find_lines("^class-map match-")
        # Input L4 output Server Farm
        # Get type node
        #type_node = Session.query(Types).filter_by(name="vip").first()
        for x in L4_lines:
            L4_name = x.replace('class-map match-all ', '')
            L4_name = L4_name.replace('class-map match-any ', '')
            print "L4 Original", L4_name
            single_L4_conf = CiscoConfParse(\
                    class_conf).find_all_children(x, exactmatch=True)
            virtual_address_lines = CiscoConfParse(\
                    single_L4_conf).find_lines("virtual-address")
            m = virtual_address_str_rx.search("".join(virtual_address_lines))
            if m != None:
                #TODO: Need to consider multiple IP
                print 'VIP Address %s' % m.group(1)
                vip_node = Device()
                ip_node = Session.query(IP).filter_by(address=m.group(1)).first()
                sql_type = Session.query(Types).filter_by(name="sqlvip").first()
                app_type = Session.query(Types).filter_by(name="appvip").first()
                if m.group(2) == "3306":
                    vip_node._types = sql_type
                else:
                    vip_node._types = app_type
                if ip_node != None:
                    vip_node.ips.append(ip_node)
                else:
                    db_ip = IP()
                    db_ip.address = m.group(1)
                    vip_node.ips.append(db_ip)
                vip_node.alias = L4_name
                # vip_node._types = type_node
                vip_node._silo = silo_node
                vip_node._instance = instance_node
            else:
                print 'VIP Address not found'
            # find policy-map that has class L4 definition
            # TODO need to get IP to map to farm
            policy_conf = parse.find_all_children("^policy-map")
            single_class_conf = CiscoConfParse(\
                    policy_conf).find_all_children('  class ' + \
                    L4_name, exactmatch=True)
            L7_policy = CiscoConfParse(\
                    single_class_conf).find_lines('  loadbalance policy ')
            # Nat start from here
            nat_dynamic = CiscoConfParse(\
                    single_class_conf).find_lines('    nat dynamic ')
            if nat_dynamic > 0:
                for nat_line in nat_dynamic:
                    match = re.search('''    nat dynamic (.*) vlan (.*)''',nat_line)
                    if match != None:
                        nat_idx, vlan_no = match.groups()
                        print 'DEBUG', nat_idx, vlan_no
                        interface = Session.query(Interface).filter(\
                                Interface.alias == "vlan "+vlan_no) \
                                .filter(\
                                Interface.silo == SILO).filter(\
                                Interface.instance == instance_node.instance_id)\
                                .first()
                        if interface != None:
                            for x in interface.details:
                                if x.parameters[:1].strip() == nat_idx:
                                    print x.parameters 
                                    vip_node.details.append(x)
                            
                        # Now we query interface
    
            # If no L7 Policy is found. it means it is a broken relation
            if len(L7_policy) == 1:
                L7_policy_name = L7_policy[0].replace(\
                        '    loadbalance policy ', '')
                print 'L7 Policy Name', L7_policy_name
                # error if policy-map can'be found
                single_policy_type_conf = CiscoConfParse(\
                        policy_conf).find_all_children(\
                        '^policy-map type loadbalance first-match ' + \
                        L7_policy_name, exactmatch=True)
                l7_detail = Detail()
                l7_detail.name = "L7_POLICY"
                l7_detail.parameters = "policy-map type loadbalance first-match " + L7_policy_name
                vip_node.details.append(l7_detail)
                if len(single_policy_type_conf) == 0:
                    # configuration error, can't find L7
                    pass
                else:
                    # error if no serverfarms is found
                    print 'single_policy_type_conf', single_policy_type_conf
                    serverfarms = CiscoConfParse(\
                            single_policy_type_conf).find_lines(\
                            '^    serverfarm|sticky-serverfarm')
                    print "serverfarms", serverfarms
                    if len(serverfarms) == 1:
                        m = serverfarm_rx.search(serverfarms[0])
                        if m != None:
                            serverfarm_name = m.group(2)
                            # serverfarm node filter by VIP
                            print 'serverfarm_name', serverfarm_name
                            if m.group(1) == "sticky-serverfarm":
                                print sticky_serverfarm_lines
                                for item in sticky_serverfarm_lines:
                                    n = sticky_rx.search(item)
                                    if n != None:
                                        sticky_name = n.group(1)
                                        # find sticky config
                                        if m.group(2) == sticky_name:
                                            single_sticky_conf = CiscoConfParse(\
                                                    sticky_serverfarm_conf) \
                                                    .find_all_children(item, \
                                                    exactmatch=True)
                                            sec_serverfarms = CiscoConfParse(\
                                                    single_sticky_conf) \
                                                    .find_lines(\
                                                    '^  serverfarm')
                                            print "single sticky conf", \
                                                    single_sticky_conf
                                            print "sec_serverfarms", \
                                                    sec_serverfarms
                                            if len(sec_serverfarms) == 1:
                                                k = sec_serverfarm_rx.search(\
                                                         sec_serverfarms[0])
                                                if k != None:
                                                    serverfarm_name = k.group(2)
                                                    print 'sticky_name', \
                                                            sticky_name
                                                    print 'serverfarm', \
                                                            serverfarm_name
                            serverfarm = Session.query(Device).filter(\
                                    Device.alias == serverfarm_name).filter(\
                                    Device.types == 2).filter(\
                                    Device.silo == SILO).filter(\
                                    Device.instance == instance_node.instance_id)\
                                    .first()
                        else:
                            serverfarm_name = None
                            serverfarm = None
                    # TODO: here we need to consider what if multiple parents exist
                    if serverfarm != None:
                        current_assoc = TreeAssoc(serverfarm, vip_node)
                        current_assoc.status = 1
                        print 'serverfarm found', serverfarm.alias
            else:
                #broken policy
                print 'L4 :', L4_name
                print "Broken Policy -------------------------------------------"
                pass
        Session.commit()
    except Exception, err:
        send_mail(str(err), "WARNING: Vipvisual lax3 parsing error", "sysadmins@gorillanation.com" )
        print str(err)
        sys.exit()

if __name__ == '__main__':
     loadconf("configs/admin.ace1.lax3.gnmedia.net")
     #loadconf("configs/apstg.ace1.lax3.gnmedia.net")
     #loadconf("configs/legacy.ace1.lax3.gnmedia.net")

