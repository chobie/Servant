module Servant
  module Mixin
    class Trigger
      
      def has_config
        return @has
      end
      
      def get_poll
        @poll
      end
      
      def get_periodical
        @periodical
      end
      
      def initialize
        @has = false
        @poll
        @periodical
      end
      
      def poll(sched)
        @has = true
        @poll = sched
      end

      def periodical(sched)
        @has = true
        @periodical = sched
      end
    end
  end
end