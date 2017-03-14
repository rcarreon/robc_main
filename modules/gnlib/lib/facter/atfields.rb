# try to load rubygems
begin
  require 'rubygems'
rescue LoadError
end

require 'net/http'
require 'net/https'
require "socket"
require 'base64'
require 'facter'
require File.dirname(__FILE__) + '/facts_cache.rb'

$at_fields_cache_file = "/etc/puppet/facts.d/at_fields.yaml"

# Logs into RT and sends a post request
def net_post_request(query)
    http = Net::HTTP.new('inventory.gnmedia.net', 80)
    #http.use_ssl = true
    http.read_timeout = 5
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    user = 'root'
    pass = 'cGFzc3dvcmQ='
    pass = Base64.decode64(pass)
    login = "user=#{user}&pass=#{pass}"
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    
    resp, data = http.post(query, login, headers)
    if resp.code == "200"
        return data
    else
        puts "Unexpected response from RT server!"
        return nil
    end
rescue Exception => e
    puts "Error connecting to RT! #{e.class}: #{e}"
    nil
end

# Returns the AssetID from RT for the given hostname
def get_assetid(hostname)
    data = net_post_request('/REST/1.0/search/asset/index.html?query=Name="'+hostname+'" and Status!="retired" and Status!="dr"')
    return nil if data.nil?
    if data =~ /No matching results/
        puts "#{hostname} is not found in AT"
        return nil
    end
    
    if data =~ /^(\d+):\s\w+/
        return $1
    else
        puts "Can't parse RT output: #{data}"
        return nil
    end
end

# Returns the data from RT for the given assetid
def get_rt_data(hostname)
    assetid = get_assetid(hostname)
    return nil if assetid.nil?
    data = net_post_request('/REST/1.0/asset/' + assetid + '/show')
    return nil if data.nil?
    
    if data =~ /Asset.*does not exist/
        puts "#{hostname} got assetid #{assetid} but assetid does not exist"
        return nil
    elsif data =~ /CF.\{ServerStatus\}: unracked/
        puts "#{hostname} got assetid #{assetid} but assetid is unracked"
        return nil
    end
    parse_asset_data(data)
end

# Converts the raw data from RT to a Ruby Hash
def parse_asset_data(data)
    hash = {}
    # Spit out parsed key,value pairs
    data.split(/\n/).each do |retval|
        if retval =~ /^(?:CF.\{)?(\w+)\}?:\s*(.*)$/
            key = "AT_#{$1}"
            value = $2
            value.gsub(" ","-")
            #puts "#{key} => #{value}"
            hash[key] = value
        end
    end
    hash
end

# Adds a custom Facter fact
def add_fact(name, value)
    Facter.add(name) do
        setcode do
            value
        end
    end
end

def main(hostname=nil)
    hostname = hostname || Socket.gethostname
	
	hash_asset_data = get_rt_data(hostname) # get data from RT
	if hash_asset_data.nil?
		# get the cached data no matter how old it is
		hash_asset_data = get_cached_facts($at_fields_cache_file, nil)
	else
		store_facts($at_fields_cache_file, hash_asset_data)
	end
    
    return nil if hash_asset_data.nil?

    hash_asset_data.each do |name, value|
        add_fact(name, value)
    end
end

# when called from the command line
if __FILE__ == $0
    hostname = ARGV[0] || Socket.gethostname 
    main(hostname)
# when loaded from a test script don't do anything
elsif $0 =~ /^test_/
    # noop
# when loaded anywhere else
else
    begin
      main
    rescue
      # We end here on some sort of failure, pass it up the chain
      raise "#{$!}"
    end
end
