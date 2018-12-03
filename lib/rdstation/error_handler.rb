require_relative 'error/formatter'
require_relative 'error_handler/conflicting_field'
require_relative 'error_handler/default'
require_relative 'error_handler/expired_access_token'
require_relative 'error_handler/expired_code_grant'
require_relative 'error_handler/invalid_credentials'
require_relative 'error_handler/resource_not_found'
require_relative 'error_handler/unauthorized'

module RDStation
  class ErrorHandler
    ERROR_TYPES = [
      ErrorHandler::ConflictingField,
      ErrorHandler::ExpiredAccessToken,
      ErrorHandler::ExpiredCodeGrant,
      ErrorHandler::InvalidCredentials,
      ErrorHandler::ResourceNotFound,
      ErrorHandler::Unauthorized,
      ErrorHandler::Default
    ].freeze

    def initialize(response)
      @response = response
    end

    def raise_errors
      error_types.each(&:raise_error)
    end

    private

    attr_reader :response

    def array_of_errors
      error_formatter.to_array.map do |error|
        error.merge(additional_error_attributes)
      end
    end

    def error_types
      ERROR_TYPES.map { |error_type| error_type.new(array_of_errors) }
    end

    def response_errors
      JSON.parse(response.body)
    end

    def error_formatter
      @error_formatter = RDStation::Error::Formatter.new(response_errors)
    end

    def additional_error_attributes
      {
        'headers' => response.headers,
        'body' => JSON.parse(response.body),
        'http_status' => response.code
      }
    end
  end
end
