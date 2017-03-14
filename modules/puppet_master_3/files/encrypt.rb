#!/usr/bin/ruby

# This script encrypts a string using Puppet's CA key
# Run this on the puppetmaster that will decrypt the string
require 'openssl'
require 'digest/sha1'
require 'base64'
require 'optparse'

def encrypt(secert, keyfile="/app/shared/ssl/ca/decrypt/ca_key.pem")
	c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
	c.encrypt
	keyfile = "/app/shared/ssl/ca/decrypt/ca_key.pem" unless File.exists?(keyfile)
	key = File.open(keyfile).read
	key = Digest::SHA1.hexdigest(key)
	c.key = key
	e = c.update(secert)
	e << c.final
	e = Base64.encode64(e)
	#puts "encrypted: #{e}\n"
	e
end

# parse options
options = {}
options_parser = OptionParser.new do |opts|
    opts.banner = "Usage: sudo #{__FILE__}"

    opts.on("-f", "--file FILENAME", "File to encrypt") do |f|
      options[:file]=f
    end
end
options_parser.parse!

if options[:file]
  if File.exists?(options[:file])
    secret = File.open(options[:file]).read
    puts encrypt(secret)
  else
    puts "Error: File does not exists #{options[:file]}"
    exit 1
  end
else
  print "Enter secret: "
  secret = gets()
  puts encrypt(secret)
end
