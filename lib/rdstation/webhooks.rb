module RDStation
  class Webhooks
    include HTTParty

    def initialize(auth_token)
      @auth_token = auth_token
    end

    def all
      response = self.class.get(base_url, headers: required_headers)
      ApiResponse.build(response)
    end

    def by_uuid(uuid)
      response = self.class.get(base_url(uuid), headers: required_headers)
      ApiResponse.build(response)
    end

    def create(payload)
      response = self.class.post(base_url, headers: required_headers, body: payload.to_json)
      ApiResponse.build(response)
    end

    def update(uuid, payload)
      response = self.class.put(base_url(uuid), headers: required_headers, body: payload.to_json)
      ApiResponse.build(response)
    end

    def delete(uuid)
      response = self.class.delete(base_url(uuid), headers: required_headers)
      return webhook_deleted_message unless response.body
      RDStation::ErrorHandler.new(response).raise_errors
    end

    private

    def webhook_deleted_message
      { message: 'Webhook deleted successfuly!' }
    end

    def base_url(path = '')
      "https://api.rd.services/integrations/webhooks/#{path}"
    end

    def required_headers
      { 'Authorization' => "Bearer #{@auth_token}", 'Content-Type' => 'application/json' }
    end
  end
end
