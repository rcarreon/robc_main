Facter.add(:mysqld_serverid) do

        setcode do
            i1,i2,i3,i4 = Facter.value('ipaddress_eth0').split('.')
            result = sprintf('%02d%03d%03d', i2, i3, i4)
        end

end
