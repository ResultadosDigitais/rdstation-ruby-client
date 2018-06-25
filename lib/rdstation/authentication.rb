# encoding: utf-8
module RDStation
  class Authentication
    include HTTParty

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    #
    # param redirect_url
    #  URL that the user will be redirected
    #  after confirming application authorization
    #
    def auth_url(redirect_url)
      "https://api.rd.services/auth/dialog?client_id=#{@client_id}&redirect_url=#{redirect_url}"
    end

    #
    # param code
    #   parameter sent by RDStation after user confirms authorization
    #
    def authenticate(code)
      request = post_to_auth_endpoint(code: code)
      return JSON.parse(request.body) unless request['error_type']
      authentication_error(request)
    end

    #
    # param refresh_token
    #   parameter sent by RDStation after authenticate
    #
    def update_access_token(refresh_token)
      post_to_auth_endpoint({ :refresh_token => refresh_token })
    end

    private

    def authentication_error(request)
      error_type = request['error_type']
      raise Exceptions::InvalidCredentials if error_type == 'ACCESS_DENIED'
      raise Exceptions::ExpiredCodeGrant if error_type == 'EXPIRED_CODE_GRANT'
    end

    def auth_token_url
      "https://api.rd.services/auth/token"
    end

    def post_to_auth_endpoint(params)
      default_body = { :client_id => @client_id, :client_secret => @client_secret }

      self.class.post(
        auth_token_url,
        headers: { 'Accept-Encoding' => 'identity' },
        body: default_body.merge(params).to_json
      )
    end
  end
end
