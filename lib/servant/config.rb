module Servant  
  class Config
    attr_accessor :ci
    
    def initialize
      @ci = nil
      @recipes = {}
    end
        
    def set_ci(ci)
      @ci = ci
    end
    
    def get_recipe
      @recipes
    end
    
    def set_recipe(recipe)
      @recipes = recipe
    end
    
    def Config.run
      ci = Servant::CI.new
      
      config = Servant::Config.new
      config.set_ci ci
      yield(config) if block_given?
      
      ci_configs = ::Servant::Mixin::Command.get_configs

      recipes = {}      
      ci_configs.each do |name, cfg|        
        if cfg.fetch(:abstract,nil)
          next
        elsif cfg.fetch(:enabled,nil) == false
          next
        else
          recipes[name] = cfg
        end
      end

      config.set_recipe recipes

      return config
    end
  end
end
