#!/usr/bin/ruby

# Creates, removes and syncs Pingdom checks with RT

require 'rubygems'
require 'json'
require 'yaml'
require 'optparse'

`logger -t pingdom Start of sync script`

def quit(exit_status)
    `logger -t pingdom End of sync script`
    exit(exit_status)
end

# Find the RT bin
if File.executable?("/usr/local/bin/rt")
  RT_BIN = "/usr/local/bin/rt"
else
  RT_BIN = `which rt`.strip
  if $?.exitstatus != 0
     $stderr.puts "Error: Could not find RT bin"
     quit(1)
  end
end

# from pingdom
CONTACTS = {
              "AdPlatform"		=> "1092281",
              "Atlas-Helios"		=> "1430363",
              "Helios"			=> "1430390",
              "Helios-Kronos"		=> "1430387",
              "Helios-Olympus"		=> "1430368",
              "SI-Tech"			=> "1430358",
              "SpringboardVideoTech"	=> "1430364",
              "TechPlatform"		=> "1430386",
              "TechPlatform-default"	=> "1430336",
              "TechTeamCrowdIgnite"	=> "1091999",
              "TechTeamCrowdIgnite-Titan"	=> "1640273",
              "OriginTech"	=> "1640286",
              "Titan"	=> "1430363",
              "wade.armstrong"		=> "1430389",
              "testing"		=> "1428915",
              "None"		=> "0",
              "Internal_IT"		=> "1430644",
              "Atlas-Helios-TechTeamCrowdIgnite"		=> "1432661",
              }


PINGDOM_CLI = "#{File.dirname(__FILE__)}/pingdom-cli"

def pingdom_cli(args)
#	puts "running #{PINGDOM_CLI} #{args}"
	out = `#{PINGDOM_CLI} #{args}`
#	puts "out: #{out}"
	return out
end


def continue?(message)
   return true unless $prompt # continue without prompting unless we're in prompt mode
   puts message
   response = STDIN.gets()
   if response =~ /yes|^y$/i
     return true
   else
     return false
   end
end

def check_sms_credits(limit=100)
   credits = pingdom_cli("credits")
   return false if $?.exitstatus != 0
   sms_credits = JSON.load(credits)['credits']['availablesms']
   $stderr.puts "Only #{sms_credits} SMS credits left! Time to buy more." if sms_credits < limit
end

def get_rt_sites()
   sites = {}
   results = `#{RT_BIN} list -t asset "Type = 'Site' AND Status = 'production' AND CF.{MonitorPriority} != 'Off'" -s`
   if $?.exitstatus != 0
     $stderr.puts "Error: Could not get sites list from RT inventory"
     quit(false)
   end
   results.each{|l| sites[l.split.last.strip]=l.split.first.strip}
   sites
end

def get_rt_info(name)
   info = `#{RT_BIN} list -l -t asset "Name = '#{name}'"`
   if $?.exitstatus != 0
     $stderr.puts "Error: Could not get info from RT inventory"
     quit(false)
   end
   YAML::load(info)
end

def get_pingdom_info(name)
   info = pingdom_cli("info #{name}")
   if $?.exitstatus != 0 or info =~ /check not found$/
     $stderr.puts "Error: Could not get info from Pingdom"
     return nil
   end
   JSON.load(info)
end

def get_pingdom_checks()
   checks = pingdom_cli("listnames")
   if $?.exitstatus != 0
     $stderr.puts "Error: Could not get checks list from Pingdom"
     quit(false)
   end
   checks.collect{|c| c.strip}.sort
end

def sendtosms?(rt_monitor_priority)
   #puts rt_monitor_priority
return false
   if rt_monitor_priority.to_s =~ /no value|Off|Low|false/
      return false
   else
     return true
   end
end

def sendtophones?(rt_monitor_priority)
   # this is used for both iphone and android
   if rt_monitor_priority.to_s =~ /no value|Off|Low|false/
      return false
   else
     return true
   end
end

# alert polocy (groups)
#Adops 1092281
#Crowdignite 1091999
#Red 1092107
# sbv 1092031
#windows 1092192

def get_alert_policy_ids(rt_notificationgroups)
  
  if rt_notificationgroups.nil?
     puts "Policy name not set! Using TechPlatform-default."
     rt_notificationgroups="TechPlatform-default"
  end

  emails = rt_notificationgroups.split(",") 
  emails.each { |x| x.gsub!(/@.*/, "") }
  policyname = emails.sort.join("-")
     
  if CONTACTS.has_key?(policyname)
     check_alert_policy_id = CONTACTS[policyname]
  else
     puts "Policy name #{policyname} not found! (using TechPlatform-default)"
     check_alert_policy_id = CONTACTS["TechPlatform-default"]
  end
  
  check_alert_policy_id
end

def add_pingdom_check(name)
  return false unless continue?("Do you want to add a Pingdom check for #{name}?\n[yes/no]")
  puts "Adding check for #{name}"
  rt_info = get_rt_info(name)
  #puts rt_info
  
  params = {}
  params["name"] = name
  params["host"] = name.split("/", 2)[0]
  params["type"] = rt_info['CF.{MonitorProtocol}'] || "http"
  params["type"].downcase!
  params["sendtoemail"] = "true"
  params["resolution"] = 1
  params["sendtosms"] = sendtosms?(rt_info['CF.{MonitorPriority}']).to_s
  params["sendtoandroid"] = sendtophones?(rt_info['CF.{MonitorPriority}']).to_s
  params["sendtoiphone"] = sendtophones?(rt_info['CF.{MonitorPriority}']).to_s
  params["alert_policy"] = new_policy = get_alert_policy_ids(rt_info['CF.{NotificationGroups}'])

  params["use_legacy_notifications"] = "false"
  params["sendnotificationwhendown"] = 3
  params["notifyagainevery"] = 60
  
  case params["type"]
    when /http/
       params["port"] = rt_info['CF.{MonitorPortNumber}'].to_i if rt_info['CF.{MonitorPortNumber}'].to_s.strip =~ /\d+/
       params["shouldcontain"] = rt_info["CF.{MonitorResultString}"] if rt_info["CF.{MonitorResultString}"].to_s.strip != ""
       params["encryption"] = "true" if rt_info['CF.{MonitorProtocol}'].to_s.downcase.strip == "https"
       params["type"] = "http" if rt_info['CF.{MonitorProtocol}'].to_s.downcase.strip == "https"
       if rt_info["CF.{MonitorURLPath}"].to_s.strip != ""
         params["url"] = rt_info["CF.{MonitorURLPath}"]
         params["url"] = "/#{params['url']}" if params["url"] !~ /^\//
       end
    when /tcp|ping/
      params["type"] = "ping"
  end
  
  #puts params.to_json
  puts pingdom_cli("add host '#{params.to_json}'")
end

def set_use_legacy_notifications(check_name, pingdom_check_info)
   old_value = pingdom_check_info["check"]["use_legacy_notifications"]
   if old_value != false
     puts "Setting legacy notifications from #{old_value} to false for #{check_name}"
     params = {"use_legacy_notifications" => "false"}
     puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
   end
end

def set_encryption(check_name, pingdom_check_info, rt_info)
  return false if rt_info['CF.{MonitorProtocol}'] !~ /HTTP/
  encryption = rt_info['CF.{MonitorProtocol}'].to_s.downcase == "https"
  params = {"encryption" => encryption.to_s}
  
  old_value = pingdom_check_info["check"]["type"]["http"]["encryption"].to_s
  new_value = params["encryption"]
  
  if old_value != new_value
    puts "Setting encryption from #{old_value} to #{new_value} for #{check_name}"
    puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
  end
end

def set_monitoruseragent(check_name, pingdom_check_info, rt_info)
  return false if rt_info['CF.{MonitorProtocol}'] !~ /HTTP/
  new_value = rt_info['CF.{MonitorUserAgent}'].to_s.strip
  old_value = pingdom_check_info["check"]["type"]["http"]["requestheaders"]["User-Agent"].to_s

  
  # pingdom places the default bot agent in for each check at creation
  # and this is a required ( can't be removed, or empty ) paramater
  # so in rt leaving it no value will be synced at as the default bot 
  # agent on the pingdom side. 
  
  # no changes are made if empty in rt, and default is set on pingdom
  # as these are in essence completely identical agent configs.
  if old_value != new_value
    if new_value == ''
      new_value = 'Pingdom.com_bot_version_1.4_(http://www.pingdom.com)'
    end 
    params = { "requestheaderUser-Agent" => "User-Agent:#{new_value}" } 
    if old_value != new_value
    puts "OLD VALUE #{old_value.to_s.strip}"
    puts "NEW VALUE #{new_value.to_s.strip}"
    pingdom_send="modifyheader #{check_name} '#{params.to_json}'"
    puts pingdom_send
    puts pingdom_cli("modifyheader #{check_name} '#{params.to_json}'")
    end
  end
end

def set_port(check_name, pingdom_check_info, rt_info)
  return false if rt_info['CF.{MonitorProtocol}'] !~ /HTTP/
  return false if rt_info['CF.{MonitorPortNumber}'].to_s !~ /\d+/
  params = { "port" => rt_info['CF.{MonitorPortNumber}'] }
  
  old_port = pingdom_check_info["check"]["type"]["http"]["port"].to_i
  new_port = params["port"]
  
  if old_port != new_port
    puts "Setting port from #{old_port} to #{new_port} for #{check_name}"
    puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
  end
end

def set_url(check_name, pingdom_check_info, rt_info)
  return false if rt_info['CF.{MonitorProtocol}'] !~ /HTTP/
  return false if rt_info["CF.{MonitorURLPath}"].to_s.strip == ""
  params = { "url" => rt_info["CF.{MonitorURLPath}"].strip }
  params["url"] = "/#{params['url']}" if params["url"] !~ /^\//
  
  old_url = pingdom_check_info["check"]["type"]["http"]["url"].to_s.strip
  new_url = params["url"]
  
  if old_url != new_url
    puts "Setting url path from #{old_url} to #{new_url} for #{check_name}"
    puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
  end
end

def set_shouldcontain(check_name, pingdom_check_info, rt_info)
  return false if rt_info['CF.{MonitorProtocol}'] !~ /HTTP/
  return false if rt_info["CF.{MonitorResultString}"].to_s.strip == ""
  params = {"shouldcontain" => rt_info["CF.{MonitorResultString}"].strip}
  
  old_value = pingdom_check_info["check"]["type"]["http"]["shouldcontain"].to_s.strip
  new_value = params["shouldcontain"]
  
  if old_value != new_value
    puts "Setting should contain string from \"#{old_value}\" to \"#{new_value}\" for #{check_name}"
    puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
  end
end

def set_sendnotificationwhendown(check_name, pingdom_check_info, n_times=3)
  old_value = pingdom_check_info["check"]["sendnotificationwhendown"].to_i
  if old_value != n_times
    puts "Setting send notification when down from #{old_value} to #{n_times} for #{check_name}"
    params = {"sendnotificationwhendown" => n_times}
    puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
  end
end

def set_notifyagainevery(check_name, pingdom_check_info, minutes=60)
   old_value = pingdom_check_info["check"]["notifyagainevery"].to_i
   if old_value != minutes
     puts "Setting notify again every from #{old_value} to #{minutes} for #{check_name}"
     params = {"notifyagainevery" => minutes}
     puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
   end
end

def set_contacts(check_name, pingdom_check_info, rt_info)
   old_policy = pingdom_check_info["check"]["alert_policy"]
   old_policy="0" if old_policy.to_s == "" # We set it 0, pingdom sets it to ""
   new_policy = get_alert_policy_ids(rt_info['CF.{NotificationGroups}'])


   if old_policy.to_s != new_policy.to_s
     puts "Setting policy for #{check_name} from .#{old_policy}. to .#{new_policy}."
     params = {}
     params["alert_policy"] = new_policy
     puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
   end
   
end

def set_sendtosms(check_name, pingdom_check_info, rt_info)
   params = { "sendtosms" => sendtosms?(rt_info['CF.{MonitorPriority}']).to_s }
   old_sms = pingdom_check_info["check"]["sendtosms"].to_s
   new_sms = params["sendtosms"]

   if old_sms != new_sms
     puts "Setting SMS alert from #{old_sms} to #{new_sms} for #{check_name}"
     puts pingdom_cli("modify #{check_name} '#{params.to_json}'")
   end
end

def set_sendtoandroid(check_name, pingdom_check_info, rt_info)
   params = { "sendtoandroid" => sendtophones?(rt_info['CF.{MonityPriority}']).to_s }
   old_android = pingdom_check_info["check"]["sendtoandroid"].to_s
   new_android = params["sendtoandroid"]

   if old_android != new_android
     puts "Setting Android alert from #{old_android} to #{new_android} for #{check_name}"
     puts pingdom_cli("modify #{check_name} '#{params.to_json}'")

   end
end

def set_sendtoiphone(check_name, pingdom_check_info, rt_info)
   params = { "sendtoiphone" => sendtophones?(rt_info['CF.{MonityPriority}']).to_s }
   old_iphone = pingdom_check_info["check"]["sendtoiphone"].to_s
   new_iphone = params["sendtoiphone"]

   if old_iphone != new_iphone
     puts "Setting iphone alert from #{old_iphone} to #{new_iphone} for #{check_name}"
     puts pingdom_cli("modify #{check_name} '#{params.to_json}'")

   end
end

# Since these fields aren't set when the check is created we have to update
# each parameter individually
def configure_check(name)
   puts name
   pingdom_check_info = get_pingdom_info(name)
   rt_info = get_rt_info(name)
   
   if pingdom_check_info
     set_use_legacy_notifications(name, pingdom_check_info)
     set_contacts(name, pingdom_check_info, rt_info)
     #set_sendtosms(name, pingdom_check_info, rt_info)
     #set_sendtoandroid(name, pingdom_check_info, rt_info)
     #set_sendtoiphone(name, pingdom_check_info, rt_info)
     #set_sendnotificationwhendown(name, pingdom_check_info)
     #set_notifyagainevery(name, pingdom_check_info)
     set_url(name, pingdom_check_info, rt_info)
     set_encryption(name, pingdom_check_info, rt_info)
     set_port(name, pingdom_check_info, rt_info)
     set_shouldcontain(name, pingdom_check_info, rt_info) 
     set_monitoruseragent(name, pingdom_check_info, rt_info)
   end
end

def remove_pingdom_check(check_name)
   return false unless continue?("Do you want to remove #{check_name} from Pingdom?\n[yes/no]")
   puts "Removing #{check_name}"
   puts pingdom_cli("delete #{check_name}")
end

# Ensure this script is run as deploy
unless ENV["USER"] == "deploy"
    $stderr.puts "ERROR: You must run this script as deploy user."
    quit(false)
end

# parse options
options = {:prompt => true, :checkname => nil}
options_parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [OPTIONS]\n\nSync script between RT inventory and Pingdom.\nAdds, modifies, and removes checks from Pingdom.\n\n"
    
    opts.on("-p", "--[no-]prompt", "Enable/disable prompting") do |p|
      options[:prompt]=p
    end
    
    opts.on("-c", "--check-name [CHECKNAME]", "Update single check") do |c|
       options[:checkname] = c
    end
end
options_parser.parse!
$prompt = options[:prompt]

# main logic
check_sms_credits()
if options[:checkname]
  #quit(true) unless continue?("Do you want to sync the Pingdom check for #{options[:checkname]} with RT?\n[yes/no]")
  configure_check(options[:checkname])
else     
  rt_sites = get_rt_sites()
  pingdom_checks = get_pingdom_checks()

  new_sites = rt_sites.keys.sort - pingdom_checks
  old_checks = pingdom_checks - rt_sites.keys.sort
  common = rt_sites.keys.sort & pingdom_checks
  
  new_sites.each{|s| add_pingdom_check(s)}
  old_checks.each{|c| remove_pingdom_check(c)}
  quit(true) unless continue?("Do you want to sync all Pingdom checks with the settings in RT?\n[yes/no]")
  common.each{|s| configure_check(s)}
end

`logger -t pingdom End of sync script`
