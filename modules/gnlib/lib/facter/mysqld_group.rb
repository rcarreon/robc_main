Facter.add(:mysqld_group) do

        setcode do
            host,vertical,env,loc,domain,tld = Facter.value('fqdn').split('.')
            offset,grp = host.split('-',2)
            group = env.upcase + ": " + grp.upcase + "." + vertical.upcase
        end

end