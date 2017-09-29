#!/usr/bin/ruby

# Imports domain info from CSV files stored in SVN to RT inventory system

require 'csv'

SVN_BIN="/usr/bin/svn"
SVN_PATH="https://svn.gnmedia.net/configmgmt/trunk/domains"
DOMAIN_FILES=`#{SVN_BIN} ls #{SVN_PATH}`.split.select{|f| File.extname(f) == ".csv"}
$rt_domains = {}
$all_domains = []

# Find the RT bin
if File.executable?("/usr/local/bin/rt")
  RT_BIN = "/usr/local/bin/rt"
else
  RT_BIN = `which rt`.strip
  if $?.exitstatus != 0
     $stderr.puts "Error: Could not find RT bin"
     quit(1)
  end
end


# Function to parse a CSV file and import to RT
def import_to_rt(filename)
  username = File.basename(filename, ".csv")
  CSV.open(filename, 'r') do |row|
    next if row.first == "DomainName" # skip headers
    
    # Our custom file with non GoDaddy domains
    if File.basename(filename) == "domains_not_in_godaddy.csv"
      domain, expiration, registrar, username, nameservers, registrant_email = row
      technical_email = ""
      admin_email = ""
    else # default to GoDaddy generated CSV report
      domain, tld, expiration, status, privacy, locked, autorenew, nameservers = row
      registrar = "GoDaddy"
      registrant_email = row[19]
      admin_email = row[31]
      technical_email = row[43]
    end
    domain = domain.upcase.strip
    $all_domains << domain
    
    # check if the domain exists in RT 
    #  if it's already in RT do an update
    #  otherwise add it to RT
    domain_id = $rt_domains[domain]
    if domain_id
      puts "Updating #{domain}: register=#{registrar} username=#{username} expiration=#{expiration} nameservers=#{nameservers} registrant_email=#{registrant_email}" 
      result = `#{RT_BIN} edit asset/#{domain_id} set Status='production' 'CF-Registrar'='#{registrar}' 'CF-Expire Date'='#{expiration}' 'CF-Username'='#{username}' 'CF-Nameservers'='#{nameservers}' 'CF-RegistrantEmail'='#{registrant_email}' 'CF-AdminEmail'='#{admin_email}' 'CF-TechnicalEmail'='#{technical_email}'`
    else
      puts "Adding #{domain}: register=#{registrar} username=#{username} expiration=#{expiration} nameservers=#{nameservers} registrant_email=#{registrant_email}" 
      result = `#{RT_BIN} create -t asset set Type='Domain' Name='DOMAIN: #{domain}' Status='production' 'CF-Registrar'='#{registrar}' 'CF-Expire Date'='#{expiration}' 'CF-Username'='#{username}' 'CF-Nameservers'='#{nameservers}' 'CF-RegistrantEmail'='#{registrant_email}' 'CF-AdminEmail'='#{admin_email}' 'CF-TechnicalEmail'='#{technical_email}'`
    end
    
    # FIXME: RT doesn't return an error code if an asset can't be updated/created do to database conflict
    if $?.success?
      puts result
    else
      $stderr.puts result
    end
  end
rescue => e
  $stderr.puts "Error parsing file #{filename}"
  $stderr.puts e.message
  exit 1
end


# find all the domains in RT and put them in a hash: { 'domain' => id }
search_results = `#{RT_BIN} list -t asset "Type='Domain'"`
unless $?.success?
   $stderr.puts "Error: Could not get domains from RT"
   quit(false)
end
search_results.each do |result|
  id, header, domain = result.split
  next if domain.nil?
  domain = domain.upcase.strip
  id.chop!
  $rt_domains[domain] = id 
end


DOMAIN_FILES.each do |file|
  `#{SVN_BIN} ls "#{SVN_PATH}/#{file}"`
  if $?.success?
    `#{SVN_BIN} export "#{SVN_PATH}/#{file}" /tmp/#{file}`
    import_to_rt("/tmp/#{file}")
  end
end


# Remove old domains
#  We should only reach this point if all the files were parsed successfully
old_domains = $rt_domains.keys - $all_domains
old_domains.each do |domain|
  puts "Removing #{domain}"
  domain_id = $rt_domains[domain]
  puts `#{RT_BIN} edit asset/#{domain_id} set Status='retired'`
end
