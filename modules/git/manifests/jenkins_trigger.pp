# usage
# git::jenkins_trigger {'name of your git repo':
#   jenkins_viewname => 'name of your jenkins view',
#   jenkins_jobname => 'name of your jenkins job',
#   jenkins_token => 'your token here',
#optional: git_repo_path => 'abs path to the git repos', #you probably need this if not applying to app*v-git.tp.prd...
# }

# example: for test-copterize repo @ http://cijoe.gnmedia.net/view/CrowdIgnite/job/test-copterize
# git::jenkins_trigger {'test-copterize': 
# jenkins_viewname => 'CrowdIgnite',
# jenkins_jobname  => 'test-copterize',
# jenkins_token    => 'test-copterize-jenkins-build-token',
# }

define git::jenkins_trigger ($git_repo = $title,
                            $jenkins_viewname = 'failed viewname',
                            $jenkins_jobname = 'failed jobname',
                            $jenkins_token = 'dne',
                            $git_repo_path = '/app/shared/git/repositories/'
                        ) {
    file { "${git_repo_path}/${git_repo}.git/hooks/post-receive":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('git/post-receive-jenkins-build.erb'),
    }   
}    
