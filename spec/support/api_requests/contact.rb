module APIRequests
  module Contact
    CONTACTS_ENDPOINT = 'https://api.rd.services/platform/contacts'.freeze

    VALID_UUID = 'valid_uuid'.freeze
    INVALID_UUID = 'invalid_uuid'.freeze
    VALID_EMAIL = 'valid@email.com'.freeze
    INVALID_EMAIL = 'invalid@email.org'.freeze

    VALID_AUTH_TOKEN = 'valid_auth_token'.freeze
    INVALID_AUTH_TOKEN = 'invalid_auth_token'.freeze
    EXPIRED_AUTH_TOKEN = 'expired_auth_token'.freeze

    CONTACT_RESPONSE = {
      status: 200,
      body: {
        name: 'Lead',
        email: 'valid@email.com'
      }.to_json
    }.freeze

    NOT_FOUND_RESPONSE = {
      status: 404,
      body: {
        error_type: 'RESOURCE_NOT_FOUND',
        error_message: 'Lead not found.'
      }.to_json
    }.freeze

    EXPIRED_TOKEN_RESPONSE = {
      status: 401,
      headers: {
        'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"'
      },
      body: {
        error_type: 'UNAUTHORIZED',
        error_message: 'Invalid token.'
      }.to_json
    }.freeze

    INVALID_TOKEN_RESPONSE = {
      status: 401,
      body: {
        error_type: 'UNAUTHORIZED',
        error_message: 'Invalid token.'
      }.to_json
    }.freeze

    def self.stub
      # GET Contacts by UUID

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/#{VALID_UUID}")
             .with(
               headers: {
                 'Authorization' => 'Bearer valid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(CONTACT_RESPONSE)

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/#{INVALID_UUID}")
             .with(
               headers: {
                 'Authorization' => 'Bearer valid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(NOT_FOUND_RESPONSE)

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/#{VALID_UUID}")
             .with(
               headers: {
                 'Authorization' => 'Bearer expired_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(EXPIRED_TOKEN_RESPONSE)

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/#{VALID_UUID}")
             .with(
               headers: {
                 'Authorization' => 'Bearer invalid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(INVALID_TOKEN_RESPONSE)


      # GET Contacts by EMAIL

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/email:#{VALID_EMAIL}")
             .with(
               headers: {
                 'Authorization' => 'Bearer valid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(CONTACT_RESPONSE)

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/email:#{INVALID_EMAIL}")
             .with(
               headers: {
                 'Authorization' => 'Bearer valid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(NOT_FOUND_RESPONSE)

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/email:#{VALID_EMAIL}")
             .with(
               headers: {
                 'Authorization' => 'Bearer expired_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(EXPIRED_TOKEN_RESPONSE)

      WebMock.stub_request(:get, "#{CONTACTS_ENDPOINT}/email:#{VALID_EMAIL}")
             .with(
               headers: {
                 'Authorization' => 'Bearer invalid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(INVALID_TOKEN_RESPONSE)
    end
  end
end
