module Servant
  module Mixin
    class Notification
      attr_accessor :addresses
      
      def has_config
        @addresses.size
      end
      
      def email(addresses)
        @addresses = addresses
      end
      
    end
  end
end
