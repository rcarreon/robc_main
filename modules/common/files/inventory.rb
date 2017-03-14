#!/usr/bin/ruby

# $Id$
# $URL$

RT_BIN = "/usr/local/bin/rt"
raise("This script needs the rt binary") unless File.exists?(RT_BIN)

FACTER_BIN = "/usr/bin/facter"
raise("This script needs the facter binary") unless File.exists?(FACTER_BIN)

def inventory()
    asset=`#{FACTER_BIN} | grep at_id | awk '{ print $3 }'`.strip
    cpu=`grep processor /proc/cpuinfo | wc -l`.strip
    mem=`free -m | grep Mem: | awk '{ print $2 }'`.strip
    os=`lsb_release -i | awk '{ print $3 }'`.strip
    version=`lsb_release -r | awk '{ print $2 }'`.strip
    puppet=`#{FACTER_BIN} puppetversion`.strip
    virtual=`#{FACTER_BIN} virtual`.strip
    
    case virtual
        when "xenu"
            manufacturer="Xen"
            description = "Virtual Machine"
        when "xen0"
            manufacturer=`dmidecode | grep -i rackable`
            description = "Xen Master"
            if $?==0
                manufacturer="Rackable"
            else
                manufacturer="Dell"
            end
        when "physical"
            manufacturer=`dmidecode | grep -i dell`
            description = "Physical"
            if $?==0
                manufacturer="Dell"
            else
                manufacturer="Unknown"
            end
        else
            raise("Unknown virtual type: #{virtual}")
    end
    
    rt_cmd = "#{RT_BIN} edit #{asset} set Description=\"#{description}\" CF-Manufacturer=#{manufacturer} CF-CPU=#{cpu} CF-Memory=#{mem} CF-OS=#{os} CF-OSVersion=#{version} CF-PuppetVersion=#{puppet}"
    system(rt_cmd)
end

if __FILE__ == $0
    user_id = `id -u`.strip
    if user_id == "0"
        inventory()
    else
        puts "This script must be run as root"
        exit 1
    end
end

