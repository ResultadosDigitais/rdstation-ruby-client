module RDStation
  class Webhooks
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    def all
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url, headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    def by_uuid(uuid)
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url(uuid), headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    def create(payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.post(base_url, headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end

    def update(uuid, payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.put(base_url(uuid), headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end

    def delete(uuid)
      retryable_request(@authorization) do |authorization|
        response = self.class.delete(base_url(uuid), headers: authorization.headers)
        return webhook_deleted_message unless response.body

        RDStation::ErrorHandler.new(response).raise_error
      end
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
