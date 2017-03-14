#!/usr/bin/ruby

require File.dirname(__FILE__) + '/puppet-build.rb'

if __FILE__ == $0
    if ARGV[0] and ARGV[1]
        puppet_build = PuppetBuild.new(ARGV[0], ARGV[1])
    else
        puppet_build = PuppetBuild.new()
        #puts "usage: ruby #{__FILE__} MODULE_PATH MANIFEST_DIR"
    end
    #puppet_build.create_docs
    puppet_build.syntax_check
end