Facter.add("mysql_monitor_agent_uuid") do
	confine :kernel => :linux
	
	agent_ini_file = "/opt/mysql/enterprise/agent/etc/mysql-monitor-agent.ini"
	uuid_gen = `which uuidgen`
	result = ""

	setcode do
	  # if there already is a uuid in the agent ini file use it
		if FileTest.exists?(agent_ini_file)
		  agent_config = File.new(agent_ini_file).read
      if agent_config =~ /agent-uuid\s?=\s?(.*)/
         result = $1
      end
    # otherwise generate a new uuid
    else
      result = `#{uuid_gen}`
		end
		result
	end
	
end
