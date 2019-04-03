module RDStation
  module Client
    class << self
      attr_reader :public_services

      delegate :contacts, :events, :fields, :webhooks, to: :public_services

      def configure
        yield config if block_given?
        set_services
      end

      def config
        @config ||= {}
      end

      private

      def set_services
        @public_services = OpenStruct.new(
          contacts: RDStation::Contacts.new(config.access_token),
          events: RDStation::Events.new(config.access_token),
          fields: RDStation::Fields.new(config.access_token),
          webhooks: RDStation::Webhooks.new(config.access_token),
        )
      end
    end
  end
end
