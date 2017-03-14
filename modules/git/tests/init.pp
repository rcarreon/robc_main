include git::client
git::jenkins_trigger {'test-copterize': 
    jenkins_viewname => 'CrowdIgnite',
    jenkins_jobname  => 'test-copterize',
    jenkins_token    => 'test-copterize-jenkins-build-token',
    git_repo_path    => '/tmp/',
}
