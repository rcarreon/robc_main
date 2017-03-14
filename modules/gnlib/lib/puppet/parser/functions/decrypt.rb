# The decrypt function does decryption
Puppet::Parser::Functions::newfunction(:decrypt, :type => :rvalue, :doc => "Decrypts a 64 based string using Puppet's CA key") do |vals|
    key_file = "#{Puppet[:ssldir]}/ca/decrypt/ca_key.pem"

    unless File.exists?(key_file)
        raise Puppet::ParseError, "There should be a CA key in place to perform decryption"
    end

    require 'openssl'
    require 'digest/sha1'
    require 'base64'
    crypted_secert = Base64.decode64(vals[0])
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.decrypt
    key = File.open(key_file).read
    key = Digest::SHA1.hexdigest(key)
    c.key = key
    d = c.update(crypted_secert)
    d << c.final
    #puts "decrypted: #{d}\n"
    d.strip
end
