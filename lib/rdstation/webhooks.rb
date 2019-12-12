module RDStation
  class Webhooks
    include HTTParty

    def initialize(authorization:)
      @authorization = authorization
    end

    def all
      response = self.class.get(base_url, headers: @authorization.headers)
      ApiResponse.build(response)
    end

    def by_uuid(uuid)
      response = self.class.get(base_url(uuid), headers: @authorization.headers)
      ApiResponse.build(response)
    end

    def create(payload)
      response = self.class.post(base_url, headers: @authorization.headers, body: payload.to_json)
      ApiResponse.build(response)
    end

    def update(uuid, payload)
      response = self.class.put(base_url(uuid), headers: @authorization.headers, body: payload.to_json)
      ApiResponse.build(response)
    end

    def delete(uuid)
      response = self.class.delete(base_url(uuid), headers: @authorization.headers)
      return webhook_deleted_message unless response.body
      RDStation::ErrorHandler.new(response).raise_error
    end

    private

    def webhook_deleted_message
      { message: 'Webhook deleted successfuly!' }
    end

    def base_url(path = '')
      "https://api.rd.services/integrations/webhooks/#{path}"
    end
  end
end
