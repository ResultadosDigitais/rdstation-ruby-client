module RDStation
  class Webhooks
    include HTTParty

    def initialize(auth_token)
      @auth_token = auth_token
    end

    def all
      response = self.class.get(base_url, headers: required_headers)
      response_body = JSON.parse(response.body)
      return response_body unless response_body['errors']
      RDStation::ErrorHandler.new(response).raise_errors
    end

    private

    def base_url(path = '')
      "https://api.rd.services/integrations/webhooks/#{path}"
    end

    def required_headers
      { 'Authorization' => "Bearer #{@auth_token}", 'Content-Type' => 'application/json' }
    end
  end
end
