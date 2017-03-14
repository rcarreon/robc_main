#!/usr/bin/ruby
#
# usage: 
#   ruby puppet-modules-build.rb        # build recently changed modules
#   ruby puppet-modules-build.rb --all  # build all modules

require File.dirname(__FILE__) + '/puppet-build.rb'

if __FILE__ == $0
    run_all = ARGV[0].to_s.downcase.include?('all')
    puppet_build = PuppetBuild.new()
    puppet_build.modules_ruby_tests
    puppet_build.modules_dry_run(run_all)
end