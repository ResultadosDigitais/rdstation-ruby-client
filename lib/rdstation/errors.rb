module RDStation
  module Errors
    ERROR_TYPES = {
      'ACCESS_DENIED' => RDStation::Error::InvalidCredentials,
      'EXPIRED_CODE_GRANT' => RDStation::Error::ExpiredCodeGrant
    }.freeze

    def self.by_type(request)
      error_type = request['error_type']
      error_message = request['error_message']
      error_class = ERROR_TYPES[error_type]
      error_class.new(error_message, request)
    end
  end
end
