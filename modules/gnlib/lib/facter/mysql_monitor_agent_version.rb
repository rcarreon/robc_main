Facter.add("mysql_monitor_agent_version") do
	confine :kernel => :linux
	
	result = "unknown"

	setcode do
		if FileTest.exists?("/opt/mysql/enterprise/agent/bin/mysql-monitor-agent")
		  version_info = `/opt/mysql/enterprise/agent/bin/mysql-monitor-agent --version`
		  if version_info =~ /mysql-monitor-agent\s([\d.]+)/
		      result =$1   
	    end
		end
		result
	end
end
