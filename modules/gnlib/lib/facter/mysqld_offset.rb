Facter.add(:mysqld_offset) do
        setcode do
            host,vertical,env,loc,domain,tld = Facter.value('fqdn').split('.')
            offset = ((((host.gsub(/[a-z]/,"").to_f) % 2).to_i)-2).abs
        end
end
