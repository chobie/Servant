module Servant
  module Mixin
    class LogRotator
      attr_accessor :config
      
      def initialize
        @has = false
        @config = Hash.new
      end
      
      def has_config
        return @has
      end
      
      def days_to_keep(days)
        @has = true
        @config[:days_to_keep] = days
      end
      
      def num_to_keep(nums)
        @has = true
        @config[:num_to_keep] = nums
      end
      
      def artifact_days_to_keep(days)
        @has = true
        @config[:artifact_days_to_keep] = days
      end
      
      def artifact_num_to_keep(nums)
        @has = true
        @config[:artifact_num_to_keep] = nums
      end

    end
  end
end