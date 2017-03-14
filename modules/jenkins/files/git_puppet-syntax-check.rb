#!/usr/bin/ruby

require File.dirname(__FILE__) + '/git_puppet-build.rb'

if __FILE__ == $0
    if ARGV[0] and ARGV[1]
        git_puppet_build = PuppetBuild.new(ARGV[0], ARGV[1])
    else
        git_puppet_build = PuppetBuild.new()
        #puts "usage: ruby #{__FILE__} MODULE_PATH MANIFEST_DIR"
    end
    #puppet_build.create_docs
    git_puppet_build.syntax_check
end
