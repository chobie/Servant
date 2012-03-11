module Servant
  module Writer
    class XmlWriter
      def initialize(config)
        @config = config
      end
      
      def get_xml()
        name = @config.fetch(:name)

        write_impl name, @config
      end
      
      def write()
        name = @config.fetch(:name)

        print write_impl name, @config
      end
      
      def write_impl(name, config)
        obj = ::Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.project do |project|
            project.actions
            project.description config.fetch(:description,nil)
            # log rotator
            
            if config.fetch(:log_rotator,nil) && config.fetch(:log_rotator).config.length > 0
              project.logRotator do |rotator|
                cfg = config.fetch(:log_rotator).config
                rotator.daysToKeep         cfg.fetch(:days_to_keep, 5)
                rotator.numToKeep          cfg.fetch(:num_to_keep, 5)
                rotator.artifactDaysToKeep cfg.fetch(:artifact_days_to_keep, -1)
                rotator.artifactNumToKeep  cfg.fetch(:artifact_num_to_keep, -1)
              end
            end
            
            project.keepDependencies false

            if config.fetch(:build_params,nil)
              project.properties do |properties|
                properties.send(:"hudson.model.ParametersDefinitionProperty") do |defi|

                  defi.parameterDefinitions do |pm|
                    # BooleanParameterDefinition
                    # PasswordParameterDefinition

                    # ChoiceParameterDefinition
                    #   choices class="java.util.Arrays$AllayList"
                    #   <name> class="string-array"
                    #     string
                    config.fetch(:build_params, nil).each do |parameter|

                      key = ""

                      case parameter[0]
                      when :bool
                        key = :"hudson.model.BooleanParameterDefinition"
                      when :string
                        key = :"hudson.model.StringParameterDefinition"
                      when :text
                        key = :"hudson.model.TextParameterDefinition"
                      when :file
                        key = :"hudson.model.FileParameterDefinition"
                      when :password
                        key = :"hudson.model.PasswordParameterDefinition"
                      when :choice
                        key = :"hudson.model.ChoiseParameterDefinition"
                      else
                        raise "does not supprot #{parameter[0]}"
                      end
                  
                      pm.send(key) do |para|
                        para.name parameter[1]
                        para.description parameter[3]
                  
                        if key == :"hudson.model.ChoiseParameterDefinition"
                        else
                          if parameter[0] == :password
                            para.defaultValue Base64.encode64(parameter[2])
                          else
                            para.defaultValue parameter[2]
                          end
                        end
                      end
                    end                   
                  end
                end
              end

            end

            # scm
            if config.fetch(:scm, nil)
              git_config = config.fetch(:scm)
              
              # for git plugin
              project.scm(:class => "hudson.plugins.git.GitSCM") do | git |
                git.configVersion git_config.fetch(:config_version)
                git.userRemoteConfigs do | r_config |
                  r_config.send(:"hudson.plugins.git.UserRemoteConfig") do | urc |
                    urc.name    git_config.fetch(:name)
                    urc.refspec git_config.fetch(:refspec)
                    urc.url     git_config.fetch(:url)
                  end
                end

                git.branches do |branches|
                  branches.send(:"hudson.plugins.git.BranchSpec") do |branch|
                    branch.name "**"
                  end
                end
                git.disableSubmodules false
                git.recursiveSubmodules false
                git.doGenerateSubmoduleConfigurations false
                git.authorOrCommitter false
                git.clean false
                git.wipeOutWorkspace false
                git.pruneBranches false
                git.remotePoll false
                git.buildChooser(:class => "hudson.plugins.git.util.DefaultBuildChooser")
                git.gitTool "Default"
                git.submoduleCfg(:class => "list")
                git.relativeTargetDir nil
                git.reference nil
                git.excludedRegions nil
                git.excludedUsers nil
                git.gitConfigName nil
                git.gitConfigEmail nil
                git.skipTag false
                git.includedRegions nil
                git.scmName nil

              end
            else 
              project.scm(:class => "hudson.scm.NullSCM")
            end

=begin          
                  <scm class="hudson.scm.SubversionSCM">
                    <locations/>
                    <excludedRegions></excludedRegions>
                    <includedRegions></includedRegions>
                    <excludedUsers></excludedUsers>
                    <excludedRevprop></excludedRevprop>
                    <excludedCommitMessages></excludedCommitMessages>
                    <workspaceUpdater class="hudson.scm.subversion.UpdateUpdater"/>
                  </scm>
=end

            project.canRoam  "true"
            project.disabled "false"
            project.blockBuildWhenDownstreamBuilding "false"
            project.blockBuildWhenUpstreamBuilding "false"

            project.triggers(:class => "vector") { |trigger|
              trigger.send(:"hudson.triggers.TimerTrigger") { |elm|
                t = config.fetch(:trigger,nil)
                if t
                  elm.spec t.get_periodical
                else
                  elm.spec nil
                end
              }
              trigger.send(:"hudson.triggers.SCMTrigger") { |elm|
                t = config.fetch(:trigger,nil)
                if t
                  elm.spec t.get_poll
                else
                  elm.spec nil
                end
              }

            }

            project.concurrentBuild "false"
            
            project.builders do |builder|
              if config.fetch(:build_steps,nil)
                builder.send(:"hudson.tasks.Shell") do |shell|
                  config.fetch(:build_steps,[]).each do |step|
                    shell.command step.fetch(:command)
                  end
                end
              end
            end
            
            project.publishers nil
            project.buildWrappers nil
          end

        end
        
        return obj.to_xml
      end
      
    end
  end
end