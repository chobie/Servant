module Servant
  class Environment
    def initialize(opts)
      @config = opts
      @logger = opts[:logger]
    end
    
    def show_help
      print "useage: servant <command> [<args>]

    list       show loaded servant jobs
    show       show current ci information
    provision  add jobs to jenkins dir and reload it
    reload     reload jenkins
    help       this information
"
    end
    
    def run

      if ARGV.size == 0
       show_help
       exit -1
      end
      
      command =  ARGV.shift
      
      case command
      when "init"
        if FileTest.exists?("ServantFile")
          print "ServantFile exists."
          exit(-1)
        end
        
        file = open("ServantFile","w")
        file.write <<'EOF'
Servant::Config.run do | config |
  config.ci.url  = "http://localhost:8080"
  
  config.ci.user = 'daemon'
  config.ci.cli  = "/tmp/moe/servant/jenkins-cli.jar"
  config.ci.home = "/home/Shared/Library/Jenkins"
  config.ci.cli_options = []

  config.ci.jobs :jobs do | jobs |
    jobs.path = "recipes"

    Dir::glob("./#{jobs.path}/*.rb").each {|name|
      jobs.add File.basename(name,".rb")
    }
  end
end
EOF
        file.close
        
        Dir::mkdir("./recipes")
      when "list"
        config = eval IO.read(File.join(Dir.pwd, "ServantFile"))
        recipes = config.get_recipe
        print "loaded configurations:\n"
        
        recipes.each do  |name,cfg|
          print "  #{name}\n"
        end
      when "show"
        config = eval IO.read(File.join(Dir.pwd, "ServantFile"))

        print "HOME: " + config.ci.home + "\n"
        print "USER: " + config.ci.user + "\n"
        print "URL:  " + config.ci.url  + "\n"
        print "CLI:  " + config.ci.cli  + "\n"

        exit
      when "provision"
        config = eval IO.read(File.join(Dir.pwd, "ServantFile"))
        recipes = config.get_recipe
        recipes.each do |name, cfg|
          @logger.info "processing `#{name}`..."
          writer = ::Servant::Writer::XmlWriter.new cfg
          xmldata = writer.get_xml
          tmp = Tempfile.new("servant")
          tmp.write xmldata
          tmp.close()
          
          `/usr/bin/java -jar #{config.ci.cli} -s #{config.ci.url} get-job #{name} 2>&1 > /dev/null`
          if $?.exitstatus == 255
            `/usr/bin/java -jar #{config.ci.cli} -s #{config.ci.url} create-job #{name} < #{tmp.path}`
          else
            `/usr/bin/java -jar #{config.ci.cli} -s #{config.ci.url} update-job #{name} < #{tmp.path}`
          end
          
          if $?.exitstatus == 0
            @logger.info "create / update job `#{name}` successfull"
          end
          
          tmp.close!
          
        end
      when "reload"
        config = eval IO.read(File.join(Dir.pwd, "ServantFile"))
        system("/usr/bin/java -jar #{config.ci.cli} -s #{config.ci.url} reload-configuration")
      else
        show_help
      end
      
      exit(0)
    end

  end
end