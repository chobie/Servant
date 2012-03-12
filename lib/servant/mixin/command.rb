module Servant
  module Mixin
    module Command
      extend self
      
      @@config  = {}
      @@configs = {}
      
      def get_binding
        trigger = Trigger.new
        log_rotator = LogRotator.new
        notification = Notification.new
               
        @trigger = trigger
        @log_rotator = log_rotator
        @notification = notification
         
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
        
        if @notification.has_config
          @@config[:notification] = @notification
        end

        @@configs[name] = @@config
        @@config = {}
      end 
    end
  end
end