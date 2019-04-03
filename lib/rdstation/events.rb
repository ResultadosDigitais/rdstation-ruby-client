module RDStation
  class Events
    include HTTParty

    EVENTS_ENDPOINT = 'https://api.rd.services/platform/events'.freeze

    def initialize(access_token:)
      @access_token = access_token
    end

    def create(payload)
      response = self.class.post(EVENTS_ENDPOINT, headers: required_headers, body: payload.to_json)
      response_body = JSON.parse(response.body)
      return response_body unless errors?(response_body)
      RDStation::ErrorHandler.new(response).raise_errors
    end

    private

    def errors?(response_body)
      response_body.is_a?(Array) || response_body['errors']
    end

    def required_headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type'  => 'application/json'
      }
    end
  end
end
