# encoding: utf-8
module RDStation
  class Authentication
    include HTTParty

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    def auth_url(redirect_url)
      "https://api.rd.services/auth/dialog?client_id=#{@client_id}&redirect_url=#{redirect_url}"
    end

    def login(code)
      post_to_auth_endpoint({ :code => code })
    end

    def update_access_token(refresh_token)
      post_to_auth_endpoint({ :refresh_token => refresh_token })
    end

    private

      def auth_token_url
        "https://api.rd.services/auth/token"
      end

      def post_to_auth_endpoint(params)
        default_body = { :client_id => @client_id, :client_secret => @client_secret }

        self.class.post(
          auth_token_url,
          :headers => {
            "Accept-Encoding": "identity"
          },
          :body => default_body.merge(params)
        )
      end
  end
end
