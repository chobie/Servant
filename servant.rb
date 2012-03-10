Servant::Config.run do | config |
  config.ci.home = "/home/Shared/Library/Jenkins"
  config.ci.user = 'daemon'
  config.ci.url  = "http://localhost:8080"
  config.ci.cli  = "/tmp/moe/servant/jenkins-cli.jar"
  config.ci.cli_options = []
  
  config.ci.jobs :jobs do | jobs |
    jobs.path = "recipes"
    
    Dir::glob("./#{jobs.path}/*.rb").each {|name|
      jobs.add File.basename(name,".rb")
    }
  end
end