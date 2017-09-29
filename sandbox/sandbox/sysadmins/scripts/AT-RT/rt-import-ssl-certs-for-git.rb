#!/usr/bin/ruby

# Imports SSL cert info from CSV files stored in GIT to RT inventory system

require 'csv'

load 'deploy.json'

GIT_BIN="/usr/bin/git"
#GIT_PATH="https://deploy:#{DEPLOY_PASSWORD}@git.gnmedia.net/configmgmt"
GIT_PATH="git@git.gnmedia.net:/configmgmt"
TMP_DIR="/tmp/ssl-certs/ssl-cert-registration"
$rt_certs = {}
$all_certs = []

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
def import_cert_to_rt(filename)
  CSV.open(filename, 'r') do |row|
    next if row.first == "CertName" # skip headers
    certname, expiration, registrar, username = row
    certname = certname.upcase.strip
    $all_certs << certname
    
    # check if the cert exists in RT 
    #  if it's already in RT do an update
    #  otherwise add it to RT
    certname_id = $rt_certs[certname]
    if certname_id
      puts "Updating #{certname}: register=#{registrar} username=#{username} expiration=#{expiration}" 
      result = `#{RT_BIN} edit asset/#{certname_id} set Status='production' 'CF-Registrar'='#{registrar}' 'CF-Expire Date'='#{expiration}' 'CF-Username'='#{username}'`
    else
      puts "Adding #{certname}: register=#{registrar} username=#{username} expiration=#{expiration}" 
      result = `#{RT_BIN} create -t asset set Type='SSLCert' Name='SSLCERT: #{certname}' Status='production' 'CF-Registrar'='#{registrar}' 'CF-Expire Date'='#{expiration}' 'CF-Username'='#{username}'`
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


# find all the certs in RT and put them in a hash: { 'cert' => id } 
search_results = `#{RT_BIN} list -t asset "Type='SSLCert'"`
unless $?.success?
   $stderr.puts "Error: Could not get SSLCerts from RT"
   quit(false)
end
search_results.each do |result|
  id, header, certname = result.split
  next if certname.nil?
  certname = certname.upcase.strip
  id.chop!
  $rt_certs[certname] = id 
end

`#{GIT_BIN} clone #{GIT_PATH} /tmp/ssl-certs`
CERT_FILES=`ls #{TMP_DIR}`.split.select{|f| File.extname(f) == ".csv"}
CERT_FILES.each do |file|
    `ls #{TMP_DIR}/#{file}`
    import_cert_to_rt("#{TMP_DIR}/#{file}")
end

# Remove old certs
#  We should only reach this point if all the files were parsed successfully
old_certs = $rt_certs.keys - $all_certs
old_certs.each do |cert|
  puts "Removing #{cert}"
  cert_id = $rt_certs[cert]
  puts `#{RT_BIN} edit asset/#{cert_id} set Status='retired'`
end

`rm -rf /tmp/ssl-certs`
