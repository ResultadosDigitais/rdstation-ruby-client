module RDStation
  class Client
    def initialize(access_token:, refresh_token: nil)
      @authorization = Authorization.new(access_token: access_token)
    end

    def contacts
      @contacts ||= RDStation::Contacts.new(authorization: @authorization)
    end

    def events
      @events ||= RDStation::Events.new(authorization: @authorization)
    end

    def fields
      @fields ||= RDStation::Fields.new(authorization: @authorization)
    end

    def webhooks
      @webhooks ||= RDStation::Webhooks.new(authorization: @authorization)
    end
  end
end
