Facter.add(:mysqld_environment) do

        setcode do
            host,vertical,env,loc,domain,tld = Facter.value('fqdn').split('.')
            result = env
        end

end