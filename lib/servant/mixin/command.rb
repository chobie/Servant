module Servant
  module Mixin
    module Command
      extend self
      
      @@config  = {}
      @@configs = {}
      
      def get_binding
        trigger = Trigger.new
        log_rotator = LogRotator.new
               
        @trigger = trigger
        @log_rotator = log_rotator
         
        binding
      end
      
      def get_configs
        @@configs
      end
      
      def push_config(name)
        if @trigger.has_config
          @@config[:trigger] = @trigger
        end

        if @log_rotator.has_config
          @@config[:log_rotator] = @log_rotator
        end

        @@configs[name] = @@config
        @@config = {}
      end 
    end
  end
end