require 'yaml'

def get_cached_facts(facts_cache_file, facts_cache_ttl=3600, debug=true)
	facts_cache_dir = File.dirname(facts_cache_file)

	if File::exist?(facts_cache_file) then
	  cache=YAML.load_file(facts_cache_file)
	  cache_time=File.mtime(facts_cache_file)
	else
	  puts "Warning: failed to load #{facts_cache_file} local cache" if debug
	  cache=nil
	  cache_time=Time.at(0)
	end

	# if we don't care how old the cache is
	return cache if facts_cache_ttl.nil?
	
	# otherwise check if the cache is too old
	return nil if (Time.now - cache_time) > facts_cache_ttl
	
	# finally return the cache
	cache
end

def store_facts(facts_cache_file, data, debug=true)
	facts_cache_dir = File.dirname(facts_cache_file)
	
	begin
	  Dir.mkdir(facts_cache_dir) if !File::exists?(facts_cache_dir)
	  File.open(facts_cache_file, 'w') do |out|
		YAML.dump( data, out)
	  end
	rescue
	  puts "Warning: failed to write #{facts_cache_file} cache file." if debug
	end
end
