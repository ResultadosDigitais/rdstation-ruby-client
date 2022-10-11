module RDStation
  class Client
    def initialize(access_token:, refresh_token: nil)
      warn_deprecation unless refresh_token
      @authorization = Authorization.new(
        access_token: access_token,
        refresh_token: refresh_token
      )
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

    def emails
      @emails ||= RDStation::Emails.new(authorization: @authorization)
    end

    private

    def warn_deprecation
      warn "DEPRECATION WARNING: Specifying refresh_token in RDStation::Client.new(access_token: 'at', refresh_token: 'rt') is optional right now, but will be mandatory in future versions. "
    end
  end
end
