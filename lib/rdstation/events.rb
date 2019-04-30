module RDStation
  class Events
    include HTTParty

    EVENTS_ENDPOINT = 'https://api.rd.services/platform/events'.freeze

    def initialize(authorization_header:)
      @authorization_header = authorization_header
    end

    def create(payload)
      response = self.class.post(EVENTS_ENDPOINT, headers: @authorization_header.to_h, body: payload.to_json)
      response_body = JSON.parse(response.body)
      return response_body unless errors?(response_body)
      RDStation::ErrorHandler.new(response).raise_error
    end

    private

    def errors?(response_body)
      response_body.is_a?(Array) || response_body['errors']
    end
  end
end
