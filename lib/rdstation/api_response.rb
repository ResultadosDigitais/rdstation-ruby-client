module RDStation
  module ApiResponse
    def self.build(response)
      response_body = JSON.parse(response.body)
      return response_body unless response_body['errors']
      RDStation::ErrorHandler.new(response).raise_errors
    end
  end
end
