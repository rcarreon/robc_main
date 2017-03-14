Facter.add("virtual") do
	# From http://reductivelabs.com/trac/puppet/wiki/Recipes/VirtualMachine
	confine :kernel => :linux
	
	result = "physical"

	setcode do
		if FileTest.exists?("/proc/xen/capabilities")
			txt = File.read("/proc/xen/capabilities")
			if txt =~ /control_d/i
				result = "xen0"
			else
				result = "xenu"
			end
		end
		result
	end
end
