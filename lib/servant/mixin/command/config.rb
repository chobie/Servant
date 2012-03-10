module Servant
  module Mixin
    module Command
      extend self
      
      def extends(file)
        @@config[:extends] = file
      end
      
      def abstract(bool)
        @@config[:abstract] = bool
      end
      
      def name(name)
        @@config[:name] = name
      end
      
      def description(description)
        @@config[:description] = description
      end
      
      def enabled(boolean)
        @@config[:enabled] = boolean
      end
      
      def build_params(param)
        unless @@config.fetch(:build_params,nil)
          @@config[:build_params] = []
        end
        
        @@config[:build_params] << param
      end
      
      def build_step(type, command)
        if defined? @@config[:build_steps]
          @@config[:build_steps] = []
        end
        
        @@config[:build_steps] << {
          :type => type,
          :command => command
        }
      end
      
      def scm_type(specs)
        repo = Repositories.new
        yield(repo) if block_given?
        
        @@config[:scm] = repo
      end
      
      def post_hook
      end
      
      class Repositories
        def initialize
          @repositories = {}
        end
        
        def fetch(key, default = nil)
          return @repositories.fetch(key, default)
        end
        
        def add(a)
          tmp = get_default_config
          
          each2(a) do |key, value|
            tmp[key] = value
          end
          
          @repositories = tmp
        end
        
        private
        def each2(array)
          i = 0
          if array.size % 2 != 0
            raise "array count error"
          end

          while i < array.size
            yield array[i], array[i+1]
            i+=2
          end
        end
        
        def get_default_config
          return {
          :config_version       => 2,
          :url                  => "",
          :name                 => "",
          :refspec              => "",
          :branches             => "",
          :disable_submodules   => false,
          :recursive_submodules => false,
          :do_generate_submodule_configurations => false,
          :author_or_committer  => false,
          :clean                => false,
          :wipe_out_workspace   => false,
          :prune_branches       => false,
          :remote_poll          => false,
          :build_chooser        => {:class => "hudson.plugins.git.util.DefaultBuildChooser"},
          :gitTool              => "default",
          :submodule_config     => {:class=>"list"},
          :relative_target_dir  => nil,
          :reference            => nil,
          :exclude_regions      => nil,
          :exclude_users        => nil,
          :git_config_name      => nil,
          :git_config_email     => nil,
          :skip_tag             => false,
          :included_regions     => nil,
          :scm_name             => nil
          }
        end
        
      end

    end
  end
end