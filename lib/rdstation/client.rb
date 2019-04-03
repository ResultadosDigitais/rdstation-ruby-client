module RDStation
  module Client
    class << self

      def configure
        yield config if block_given?
      end

      def config
        @config ||= {}
      end
      
      def contacts
        validate_config
        RDStation::Contacts.new(config[:access_token])
      end
      
      def events
        validate_config
        RDStation::Events.new(config[:access_token])
      end
      
      def fields
        validate_config
        RDStation::Fields.new(config[:access_token])
      end
      
      def webhooks
        validate_config
        RDStation::Webhooks.new(config[:access_token])
      end
      
      private
      
      def validate_config
        access_token_msg = ":access_token is required in configuration"
        raise InvalidConfiguration.new(access_token_msg) unless config[:access_token]
      end
    end
  end
end
