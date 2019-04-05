module RDStation
  class AuthorizationHeader
    
    def initialize(access_token:)
      @access_token = access_token
      validate_access_token access_token
    end
    
    def to_h
      { "Authorization" => "Bearer #{@access_token}", "Content-Type" => "application/json" }
    end
    
    private
    
    def validate_access_token(access_token)
      access_token_msg = ':access_token is required'
      raise ArgumentError, access_token_msg unless access_token
    end
    
  end
end