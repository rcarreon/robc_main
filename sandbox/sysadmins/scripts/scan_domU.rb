#!/usr/bin/ruby

# Load custom facts path
ENV["FACTERLIB"] = "/var/lib/puppet/lib/facter" if ENV["FACTERLIB"].nil?

$rt_bin = "/usr/local/bin/rt"
raise("This script needs the rt binary") unless File.exists?($rt_bin)

$facter_bin = "/usr/bin/facter"
raise("This script needs the facter binary") unless File.exists?($facter_bin)

def inventory()
    asset=`#{$facter_bin} | grep at_id | awk '{ print $3 }'`.strip
    #cpu=`grep processor /proc/cpuinfo | wc -l`.strip
    #mem=`free -m | grep Mem: | awk '{ print $2 }'`.strip
    os=`lsb_release -i | awk '{ print $3 }'`.strip
    version=`lsb_release -r | awk '{ print $2 }'`.strip
    puppet=`#{$facter_bin} puppetversion`.strip
    virtual=`#{$facter_bin} virtual`.strip
    
    case virtual
        when "kvm"
            manufacturer="KVM"
            if File.exists?("/opt/xcat/xcatinfo")
                description = "xCAT KVM Virtual Machine"
            else
                description = "KVM Virtual Machine"
            end

        when "xenu"
            manufacturer="Xen"
            description = "Virtual Machine"
        when "xen0"
            manufacturer=`/usr/sbin/dmidecode | grep -i rackable`
            description = "Xen Master"
            if $?==0
                manufacturer="Rackable"
            else
                manufacturer=`lspci -n -s 04:00.1 | grep -q 8086:1096`
                if $?==0
                    manufacturer="Rackable" # Some rackables don't say it
                else
                    manufacturer="Dell"
                end
            end
        when "physical"
            manufacturer=`/usr/sbin/dmidecode | grep -i dell`
            description = "Physical"
            if $?==0
                manufacturer="Dell"
            else
                manufacturer="Unknown"
            end
        else
            raise("Unknown virtual type: #{virtual}")
    end
    
    rt_cmd = "#{$rt_bin} edit #{asset} set Description=\"#{description}\" CF-Manufacturer=#{manufacturer} CF-OS=#{os} CF-OSVersion=#{version} CF-PuppetVersion=#{puppet}"
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
