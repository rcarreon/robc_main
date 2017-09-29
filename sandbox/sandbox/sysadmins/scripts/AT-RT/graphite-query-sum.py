#!/usr/bin/env python
# -*- coding: utf-8 -*-
import urllib2
from email.MIMEText import MIMEText
from email.MIMEMultipart import MIMEMultipart
import smtplib
import optparse
import operator
#response = urllib2.urlopen("http://graphite.gnmedia.net/render/?width=1373&height=709&_salt=1327023797.918&target=sumSeries%28app*v-jm_ao_prd_lax_gnmedia_net.tail.craveonline_com.counter.503.value%29&rawData=true")
__version__ = "1.0"

sites = [\
"bufferzone_craveonline_com",
"craveonline_com",
"dvdfile_com",
"hoopsvibe_com",
#"idealsite_gnmedia_net",
"launch_gamerevolution_com",
"liveoutdoors_com",
"momtastic_com",
"movieguide_comingsoon_net",
"movieguide_shocktillyoudrop_net",
"origin_bufferzone_craveonline_com",
"origin_craveonline_com",
"origin_dvdfile_com",
"origin_hoopsvibe_com",
#"origin_idealsite_gnmedia_net",
"origin_launch_gamerevolution_com",
"origin_liveoutdoors_com",
"origin_momtastic_com",
"origin_movieguide_comingsoon_net",
"origin_movieguide_shocktillyoudrop_com",
"origin_pacman_craveonline_com",
"origin_ringtv_craveonline_com",
#"origin_shocktillyoudrop_net",
"origin_superherohype_com",
"origin_thefashionspot_com",
"origin_training_sherdog_com",
"origin_wrestlezone_com",
"pacman_craveonline_com",
"ringtv_craveonline_com",
"shocktillyoudrop_com",
"superherohype_com",
"thefashionspot_com",
"training_sherdog_com",
"wrestlezone_com",
]

requests = [ \
[500, "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.%s.counter.500.value)&rawData=true"],
[503, "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.%s.counter.503.value)&rawData=true"],
[404, "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.%s.counter.404.value)&rawData=true"],
[200, "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.%s.counter.200.value)&rawData=true"],
]

overall_reqeusts = { \
"500": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.500.value)&from=-1days",
"500-week": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.500.value)&from=-7days",
"500-month": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.500.value)&from=-30days",
"503": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.503.value)&from=-1days",
"503-week": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.503.value)&from=-7days",
"503-month": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.503.value)&from=-30days",
"404": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.404.value)&from=-1days",
"404-week": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.404.value)&from=-7days",
"404-month": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.404.value)&from=-30days",
"200": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.200.value)&from=-1days",
"200-week": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.200.value)&from=-7days",
"200-month": "http://graphite.gnmedia.net/render/?width=1024&height=768&_salt=1327372628.039&target=sumSeries(app*v-jm_ao_prd_lax_gnmedia_net.tail.*.counter.200.value)&from=-30days",
}

def send_mail(content,html_content, subject,send_to):
    print "executing send_mail function"
    #MAIL = "/bin/mailx"
    #pp = os.popen("%s \"%s\" -s \"%s\" -v" % (MAIL, send_to, subject),"w")
    #result = "Hi,\nThe following domains/SSL will be expired soon:\n\n" + content
    #pp.write(result)
    #exitcode = pp.close()
    #if exitcode:
    #    return "Exit code is %s" % exitcode
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = 'PB Stats Reporter \
        <TechnologyPlatform@gorillanation.com>'
    msg['To'] = send_to
    part1 = MIMEText(content, 'plain')
    part2 = MIMEText(html_content, 'html')
    msg.attach(part1)
    msg.attach(part2)
    send = smtplib.SMTP('localhost')
    send.sendmail(msg['From'], [msg['To']], msg.as_string())
    send.quit()

def main():
    description = "A Graphite Stats Gathering Program"
    version = "%prog " + __version__
    parser = optparse.OptionParser(description=description, version=version)
    parser.set_defaults(verbose=False)
    parser.add_option('--recipient', '-r',
                         help='Recipient (if set an email will be sent)')
    options, arguments = parser.parse_args()
    RECIPIENT = str(options.recipient)
    content = ""
    # Gather Site Stats
    site_list = []
    sorted_site_list = []
    # Sorted by number of 200 hits
    for site in sites:
        single_node = {}
        single_node["site"] = site.replace("_",".")
        for return_code, request in requests:
            counter = 0
            response = urllib2.urlopen(request % site)
            html = response.read()
            
            tmp = html.split('|')
            
            description = tmp[0].split(",")
            stats = tmp[1].split(",")
            for singleData in stats:
               if singleData.strip("\n") == 'None':
                   continue
               target = int(float(singleData.strip("\n")))
               counter += target
            single_node[str(return_code)] = counter
            single_node[str(return_code) + '-url-day'] = ((request % site).replace('&rawData=true','&from=-1days'))
            single_node[str(return_code) + '-url-week'] = ((request % site).replace('&rawData=true','&from=-7days'))
            single_node[str(return_code) + '-url-month'] = ((request % site).replace('&rawData=true','&from=-30days'))
        site_list.append(single_node)
        print "parsing single node" , single_node
    for key in sorted(site_list, key=operator.itemgetter("200"),reverse=True):
        sorted_site_list.append(key)
    content = ""
    html_content = ""
    html_content += "* You can also change the days field in the URL to modify the time range *"
    content += "PB Aggregate Apache Return\r\n"
    html_content += "<br />PB Aggregate Apache Return<br />"
    total_500 = 0
    total_200 = 0
    total_503 = 0
    total_404 = 0
    for site in sorted_site_list:
        total_500 += site['500']
        total_200 += site['200']
        total_404 += site['404']
        total_503 += site['503']
    content = "PebbleBed\r\n"
    html_content = "PebbleBed<br />"
    content += "    200 : %d\r\n" % total_200
    html_content += "    200 : %d " % total_200
    html_content += "<a href='%(200)s'/>day</a> - <a href='%(200-week)s'/>week</a> - <a href='%(200-month)s'/>month</a><br />" % overall_reqeusts
    content += "    500 : %d\r\n" % total_500
    html_content += "    500 : %d " % total_500
    html_content += "<a href='%(500)s'/>day</a> - <a href='%(200-week)s'/>week</a> - <a href='%(200-month)s'/>month</a><br />" % overall_reqeusts
    content += "    503 : %d\r\n" % total_503
    html_content += "    503 : %d " % total_503
    html_content += "<a href='%(503)s'/>day</a> - <a href='%(200-week)s'/>week</a> - <a href='%(200-month)s'/>month</a><br />" % overall_reqeusts
    content += "    404 : %d\r\n" % total_404
    html_content += "    404 : %d " % total_404
    html_content += "<a href='%(404)s'/>day</a> - <a href='%(200-week)s'/>week</a> - <a href='%(200-month)s'/>month</a><br />" % overall_reqeusts
    html_content += "------------------------------------------------------------------------------------------------------<br />"

    for site in sorted_site_list:
        #content += "Site   : %(site)s \r\n    200: %(200)d \r\n    500: %(500)d \r\n    503: %(503)d\r\n\r\n" % site
        content += "Site    : %(site)s\r\n" % site
        html_content += "<br />Site    : %(site)s<br />" % site
        content += "    200 : %(200)d\r\n" % site
        html_content += "    200 : %(200)d " % site
        html_content += "<a href='%(200-url-day)s'/>day</a> -- <a href='%(200-url-week)s'/>week</a> -- <a href='%(200-url-month)s'/>month</a><br />" %site
        if site['500'] != 0:
            content += "    500 : %(500)d\r\n" % site
            html_content += "    500 : %(500)d " % site
            html_content += "<a href='%(500-url-day)s'/>day</a> -- <a href='%(500-url-week)s'/>week</a> -- <a href='%(500-url-month)s'/>month</a><br />" %site
        if site['503'] != 0:
            content += "    503 : %(503)d\r\n" % site
            html_content += "    503 : %(503)d " % site
            html_content += "<a href='%(503-url-day)s'/>day</a> -- <a href='%(503-url-week)s'/>week</a> -- <a href='%(503-url-month)s'/>month</a><br />" %site
        if site['404'] != 0:
            content += "    404 : %(404)d\r\n" % site
            html_content += "    404 : %(404)d " % site
            html_content += "<a href='%(404-url-day)s'/>day</a> -- <a href='%(404-url-week)s'/>week</a> -- <a href='%(404-url-month)s'/>month</a><br />" %site
    send_mail(content, html_content, "Daily Pebblebed Sites APP Stats (Apache return) ", RECIPIENT)
        
if __name__ == "__main__":
    main()
