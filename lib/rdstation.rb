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
  end
end