# gn_lsb_two_digits

require 'gn_lsb_two_digits'
    Facter.add(:gn_lsb_two_digits) do
      setcode do
        Facter.value(:lsbdistrelease).match('([0-9]\.[0-9]).*').captures
      end
    end
