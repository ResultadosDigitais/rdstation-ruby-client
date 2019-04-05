module RDStation
  class Client
    def initialize(access_token:)
      @authorization_header = AuthorizationHeader.new(access_token: access_token)
    end
    
    def contacts
      @contacts ||= RDStation::Contacts.new(authorization_header: @authorization_header)
    end

    def events
      @events ||= RDStation::Events.new(authorization_header: @authorization_header)
    end

    def fields
      @fields ||= RDStation::Fields.new(authorization_header: @authorization_header)
    end

    def webhooks
      @webhooks ||= RDStation::Webhooks.new(authorization_header: @authorization_header)
    end
  end
end
