module RDStation
  module ApiResponse
    def self.build(response)
      return JSON.parse(response.body) if response.code.between?(200, 299)

      RDStation::ErrorHandler.new(response).raise_error
    end

    def self.build_with_headers(response)
      return response if response.code.between?(200, 299)

      RDStation::ErrorHandler.new(response).raise_error
    end
  end
end
