#!/usr/bin/ruby
#
# usage: 
#   ruby puppet-modules-build.rb        # build recently changed modules
#   ruby puppet-modules-build.rb --all  # build all modules

require File.dirname(__FILE__) + '/git_puppet-build.rb'

if __FILE__ == $0
    run_all = ARGV[0].to_s.downcase.include?('all')
    git_puppet_build = PuppetBuild.new()
    git_puppet_build.modules_ruby_tests
    git_puppet_build.modules_dry_run(run_all)
end
