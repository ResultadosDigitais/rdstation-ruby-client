module RDStation
  class ErrorHandler
    attr_reader :handlers

    def initialize
      @handlers = []
    end

    def register_handler(handler)
      @handlers << handler
    end
  end
end
