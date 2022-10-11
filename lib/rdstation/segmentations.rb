module RDStation
  class Segmentations
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

    def contacts(segmentation_id)
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url("#{segmentation_id}/contacts"), headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    private

    def base_url(path = '')
      "#{RDStation.host}/platform/segmentations/#{path}"
    end
  end
end
