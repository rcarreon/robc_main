require 'facter'

$dmidecode = "/usr/sbin/dmidecode"

# Only run on Xen Masters
if File.exist?("/dev/xen")

	# Helper function: adds a custom Facter fact
	def add_fact(name, value)
		Facter.add(name) do
			setcode do
				value
			end
		end
	end

	# Get the number of memory banks
	physical_mem_arry_info = `#{$dmidecode} -t 16`
	if $?.exitstatus ==  0
		mem_banks_count = physical_mem_arry_info[/Number Of Devices:.*/][/\d+$/].strip
		add_fact("physical_memory_banks", mem_banks_count)
	end

	# Get the size of each memory bank
	mem_devices_info = `#{$dmidecode} -t 17`
	if $?.exitstatus ==  0
		membanks = mem_devices_info.select{|l| l =~ /Size:/}
		membanks.each_index do |index|
			mem_size = membanks[index].strip.split(":").last.strip
			add_fact("memory_bank#{index}", mem_size)
		end
	end

end