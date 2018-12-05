# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/contacts
  class Events
    include HTTParty

    EVENTS_ENDPOINT = 'https://api.rd.services/platform/events'.freeze

    def initialize(auth_token)
      @auth_token = auth_token
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
        'Authorization' => "Bearer #{@auth_token}",
        'Content-Type'  => 'application/json'
      }
    end
  end
end
