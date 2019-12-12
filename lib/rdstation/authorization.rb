module RDStation
  class Authorization
    attr_reader :refresh_token
    attr_accessor :access_token
    def initialize(access_token:, refresh_token: nil)
      @access_token = access_token
      @refresh_token = refresh_token
      validate_access_token access_token
    end

    def headers
      { "Authorization" => "Bearer #{@access_token}", "Content-Type" => "application/json" }
    end

    private

    def validate_access_token(access_token)
      access_token_msg = ':access_token is required'
      raise ArgumentError, access_token_msg unless access_token
    end

  end
end