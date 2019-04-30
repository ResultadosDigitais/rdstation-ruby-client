module RDStation
  module ApiResponse
    def self.build(response)
      response_body = JSON.parse(response.body)
      return response_body if response.code.between?(200, 299)

      RDStation::ErrorHandler.new(response).raise_error
    end
  end
end
