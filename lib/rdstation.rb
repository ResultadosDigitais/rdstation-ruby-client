module RDStation
  class << self
    attr_accessor :configuration

    HOST = 'https://api.rd.services'.freeze

    def configure
      self.configuration ||= Configuration.new
      self.configuration.base_host = HOST
      yield(configuration)
    end

    def host
      self.configuration&.base_host || HOST
    end
  end

  class Configuration
    attr_accessor :client_id, :client_secret, :base_host
    attr_reader :access_token_refresh_callback

    def on_access_token_refresh(&block)
      @access_token_refresh_callback = block
    end
  end
end
