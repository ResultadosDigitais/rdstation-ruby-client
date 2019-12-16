module RDStation
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
  
  class Configuration
    attr_accessor :client_id, :client_secret
    attr_reader :access_token_refresh_callback

    def on_access_token_refresh(&block)
      @access_token_refresh_callback = block
    end
  end
end
