#!/usr/bin/ruby

require 'yaml'
require 'fileutils'

STDOUT.sync = true
$verbose = false

module GIT
    GIT_OPTIONS = ""
    GIT_BIN = `which git`.strip
    GIT_CMD = "\"#{GIT_BIN}\" #{GIT_OPTIONS}"

    def self.git_info
        git_info_cmd = "#{GIT_CMD} status"
        puts git_info_cmd if $verbose
        git_info = `cd modules; #{git_info_cmd}`
        fail("Error retrieving git info") if $? != 0
        git_info = YAML::load(git_info)
        puts git_info if $verbose
        git_info
    end

    def self.get_last_revision
        last_rev = "#{GIT_CMD} rev-parse HEAD~1"
        puts last_rev if $verbose
        last_rev
    end

    def self.get_changes(repo_dir="modules", start_rev="HEAD~1")
        start_rev = get_last_revision if start_rev.nil?
        git_diff_cmd = "#{GIT_CMD} diff --name-only --diff-filter=AM #{start_rev}"
        puts git_diff_cmd if $verbose
        changes = `cd #{repo_dir}; #{git_diff_cmd}`.split("\n")
        fail("Error retrieving git diff") if $? != 0
        puts changes if $verbose
        changes
    end
end

class PuppetBuild
    PUPPET_BIN = `which puppet`.strip
    PUPPETDOC_BIN = `which puppetdoc`.strip

    RUBY_BIN = `which ruby`.strip

    def initialize(modulepath="modules", manifestdir="manifests", templatedir="templates")
        @modulepath = modulepath
        @manifestdir = manifestdir
        @templatedir = templatedir
    end
    
    private
    def get_changed_modules()
        changes = GIT::get_changes(@modulepath)
        
        # make a Hash of all the changed modules
        changed_modules = {}
        changes.each do |file|
            if file =~ /([^\/]+)\//
                module_name = $1
                changed_modules[module_name] = 1
            end
        end
        
        changed_modules.keys
    end
    
    def puppet_file_syntax_check(file)
        puts "Checking puppet syntax of #{file}"
        puppet_cmd = "#{PUPPET_BIN} parser validate --color=false --manifestdir \"#{@manifestdir}\" --modulepath \"#{@modulepath}\" --confdir=/tmp --vardir=/tmp} #{file}"
        puts puppet_cmd
        puts `#{puppet_cmd}`
        fail("Syntax error in #{file}") if $? != 0
    end

    def ruby_template_syntax_check(file)
        puts "Checking erb syntax of #{file}"
        syntax_check_cmd = "erb -x -T '-' #{file} | #{RUBY_BIN} -c"
        puts syntax_check_cmd
        puts `#{syntax_check_cmd}`
        fail("Syntax error in #{file}") if $? != 0
    end

    def ruby_file_syntax_check(file)
        puts "Checking ruby syntax of #{file}"
        syntax_check_cmd = "#{RUBY_BIN} -c #{file}"
        puts syntax_check_cmd
        puts `#{syntax_check_cmd}`
        fail("Syntax error in #{file}") if $? != 0
    end
    
    def dry_run(test_file)
        name = test_file
        if test_file =~ /#{@modulepath}\/(.+)\/tests\/.+\.pp/
            name = $1
        end
        puts "Starting dry run of #{name}"
        puppet_cmd = "sudo #{PUPPET_BIN} apply --noop --no-storeconfigs --color=false --templatedir \"#{@templatedir}\" --manifestdir \"#{@manifestdir}\" --modulepath \"#{@modulepath}\" \"#{test_file}\""
        puts puppet_cmd
        dry_run_log = `#{puppet_cmd}`
        puts dry_run_log
        puts "[status code]: #{$?}"
        fail("#{name} puppet dry run failed!") if (dry_run_log =~ /^err:/) or ($? != 0)
        puts "#{name} PASSED\n"
    end
    
    def cp_silo_file(silo="lax3")
        FileUtils.rm_f("#{@manifestdir}/silo.pp") if File.exists?("#{@manifestdir}/silo.pp")
        FileUtils.cp("#{@manifestdir}/silo.pp.#{silo}", "#{@manifestdir}/silo.pp") if File.exists?("#{@manifestdir}/silo.pp.#{silo}")
    end
    
    public
    def syntax_check()
        cp_silo_file()
        
        changes = GIT::get_changes(@modulepath) + GIT::get_changes(@manifestdir)
        puts changes
        changes.each do |change|
            ext = File.extname(change).strip
            case ext
                when ".pp"
                    puppet_file_syntax_check(change)
                when ".erb"
                    ruby_template_syntax_check(change)
                when ".rb"
                    ruby_file_syntax_check(change)
                else
                    puts "Unknown file type: #{change}. Skipping syntax check."
            end
        end
    end

    def create_docs()
        FileUtils.rm_rf("doc")
        puppetdoc_cmd = "#{PUPPETDOC_BIN} --mode rdoc --outputdir doc --modulepath \"#{@modulepath}\"  --manifestdir \"#{@manifestdir}\""
        puts puppetdoc_cmd
        `#{puppetdoc_cmd}`
    end

    def modules_dry_run(run_all=false)
        changed_modules = get_changed_modules()
        test_for_changed_modules = []
        changed_modules.each do |module_name|
            test_for_changed_modules += Dir.glob("#{@modulepath}/#{module_name}/tests/*.pp")
        end
        
        tests = test_for_changed_modules
        if run_all
            all_tests = Dir.glob("#{@modulepath}/*/tests/*.pp")
            # test the recently changed modules first
            tests = test_for_changed_modules + (all_tests - test_for_changed_modules)
        end
        
        puts tests
        tests.each do |test_file|
            dry_run(test_file)
        end
    end
    
    def all_modules_dry_run
        modules_dry_run(true)
    end
    
    def modules_ruby_tests
        ruby_tests = Dir.glob("#{@modulepath}/**/test_*.rb")
        
        ruby_tests.each do |ruby_test|
            ruby_test_cmd = "#{RUBY_BIN} #{ruby_test}"
            puts ruby_test_cmd
            puts `#{ruby_test_cmd}`
            fail("Test failure in: #{ruby_test}") if $? != 0
        end
    end
    
    def nodes_dry_run(run_all=false)
        cp_silo_file()
        if run_all
            nodes = Dir.glob("#{@manifestdir}/nodes/**/*.pp")
        else
            nodes = GIT::get_changes(@manifestdir)
        end
        nodes.each do |node|
            puts node
            File.open('node_test.pp', 'w') do |file|
                file.puts "import '#{@manifestdir}/site.pp'"
                file.puts "import '#{@manifestdir}/#{node}'"
            end
            dry_run('node_test.pp')
        end
    end
end
