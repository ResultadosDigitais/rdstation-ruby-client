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
        @contacts ||= RDStation::Contacts.new(access_token: access_token)
      end

      def events
        validate_config
        @events ||= RDStation::Events.new(access_token: access_token)
      end

      def fields
        validate_config
        @fields ||= RDStation::Fields.new(access_token: access_token)
      end

      def webhooks
        validate_config
        @webhooks ||= RDStation::Webhooks.new(access_token: access_token)
      end

      private

      def access_token
        config[:access_token]
      end

      def validate_config
        access_token_msg = ':access_token is required in configuration'
        raise InvalidConfiguration, access_token_msg unless access_token
      end
    end
  end
end
