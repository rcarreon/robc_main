#!/usr/bin/ruby
#
# usage: 
#   ruby puppet-nodes-build.rb        # build recently changed nodes
#   ruby puppet-nodes-build.rb --all  # build all nodes

require File.dirname(__FILE__) + '/git_puppet-build.rb'

if __FILE__ == $0
    run_all = ARGV[0].to_s.downcase.include?('all')
    git_puppet_build = PuppetBuild.new()
    git_puppet_build.nodes_dry_run(run_all)
end
