module APIRequests
  module Authentication
    ACCESS_TOKEN_ENDPOINT = 'https://api.rd.services/auth/token'.freeze
    CLIENT_ID = 'client_id'.freeze
    CLIENT_SECRET = 'client_secret'.freeze

    VALID_TOKEN_REQUEST_BY_CODE = {
      headers: { 'Accept-Encoding' => 'identity' },
      body: {
        client_id: 'client_id',
        client_secret: 'client_secret',
        code: 'valid_code'
      }.to_json
    }.freeze

    TOKEN_REQUEST_WITH_EXPIRED_CODE = {
      headers: { 'Accept-Encoding' => 'identity' },
      body: {
        client_id: 'client_id',
        client_secret: 'client_secret',
        code: 'expired_code'
      }.to_json
    }.freeze

    TOKEN_REQUEST_WITH_INVALID_CODE = {
      headers: { 'Accept-Encoding' => 'identity' },
      body: {
        client_id: 'client_id',
        client_secret: 'client_secret',
        code: 'invalid_code'
      }.to_json
    }.freeze

    TOKEN_RESPONSE = {
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        'access_token' => '123456',
        'expires_in' => 86_400,
        'refresh_token' => 'refreshtoken'
      }.to_json
    }.freeze

    EXPIRED_CODE_RESPONSE = {
      status: 401,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        error_type: 'EXPIRED_CODE_GRANT',
        error_message: 'The authorization code grant has expired.'
      }.to_json
    }.freeze

    INVALID_CODE_RESPONSE = {
      status: 401,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        error_type: 'ACCESS_DENIED',
        error_message: 'Wrong credentials provided.'
      }.to_json
    }.freeze

    def self.stub
      WebMock.stub_request(:post, ACCESS_TOKEN_ENDPOINT)
             .with(VALID_TOKEN_REQUEST_BY_CODE)
             .to_return(TOKEN_RESPONSE)

      WebMock.stub_request(:post, ACCESS_TOKEN_ENDPOINT)
             .with(TOKEN_REQUEST_WITH_EXPIRED_CODE)
             .to_return(EXPIRED_CODE_RESPONSE)

      WebMock.stub_request(:post, ACCESS_TOKEN_ENDPOINT)
             .with(TOKEN_REQUEST_WITH_INVALID_CODE)
             .to_return(INVALID_CODE_RESPONSE)
    end
  end
end
