# Servant

Servant is a tool for management such a messy Jenkins jobs.
It provides simple, inheritable and powerful configuration file which represents Jenkins's job xml.

# Installation

````
gem install servant
````

# Requirements

* jenkins (1.440 higher as it supports update-job command)
* jenkins-cli
* log4r
* nokogiri

# Quick Setup

````
mkdir Jobs
cd Jobs
servant init
cat > recipes/first_job.rb <<EOF
name "first_job"
description "my first job for jenkins"
EOF

servant provision
# this will add first_job job to localhost jenkins and reload.

````

# Servant Configurations

Servant requires ServantFile on your project directory.

````ruby
Servant::Config.run do | config |
  config.ci.url  = "http://localhost:8080"
  
  config.ci.cli  = "/tmp/moe/servant/jenkins-cli.jar"
  config.ci.cli_options = []

  # optional (for update config.xml directly)
  config.ci.user = 'daemon'
  config.ci.home = "/home/Shared/Library/Jenkins"

  config.ci.jobs :jobs do | jobs |
    jobs.path = "recipes"

    Dir::glob("./#{jobs.path}/*.rb").each {|name|
      jobs.add File.basename(name,".rb")
    }
  end
end
````

# Commands

````
servant provision
servant reload
````

# job Configurations

````ruby
# meta data (required)
name                 "php-sundown-release-build"
description          "php-sundown is a fast markdown parser & render"
enabled               true

# abstract means: don't register job
abstract              false

# extends means: inherit specified servant job 
extends               "parent_task"

# log_rotator (optional)
log_rotator.days_to_keep          5
log_rotator.num_to_keep           5
log_rotator.artifact_days_to_keep 5
log_rotator.artifact_num_to_keep  5

# triggers (optional)
trigger.poll          "* * * * *"
trigger.periodical    "* * * * *"

# build parameters (optional)
build_params          [:text,     "name","default", "description"]
build_params          [:password, "name","default", "description"]
build_params          [:file,     "name","default", "description"]
build_params          [:bool,     "name","default", "description"]
build_params          [:choice,   "name","default", "description", ["choices..."]]
build_params          [:string,   "name","default", "description"]

# build steps (optional)
build_step            :shell_script, <<-EOH
  cd {$HOME}
  phpunit
EOH

# repository definition (optional)
scm_type :git do | repositories |
  repositories.add [
    :config_version, 2,
    :url     , "https://github.com/chobie/php-sundown.git",
    :name    , "",
    :refspec , "",
    :branches, "",
  ]
end
````
# License

MIT License

# Supported features

* log rotator
* trigger
* build_params
* build step
* Git
