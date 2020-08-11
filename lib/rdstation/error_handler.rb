require_relative 'error/formatter'
require_relative 'error_handler/bad_request'
require_relative 'error_handler/unauthorized'

module RDStation
  class ErrorHandler
    def initialize(response)
      @response = response
      @code = response.code
    end

    def raise_error
      raise error_class, array_of_errors.first if error_class < RDStation::Error

      error_class.new(array_of_errors).raise_error
    rescue JSON::ParserError => error
      raise error_class, { 'error_message' => response.body }
    end

    private

    attr_reader :response, :code

    def error_class
      case code
      when 400      then RDStation::ErrorHandler::BadRequest
      when 401      then RDStation::ErrorHandler::Unauthorized
      when 403      then RDStation::Error::Forbidden
      when 404      then RDStation::Error::NotFound
      when 405      then RDStation::Error::MethodNotAllowed
      when 406      then RDStation::Error::NotAcceptable
      when 409      then RDStation::Error::Conflict
      when 415      then RDStation::Error::UnsupportedMediaType
      when 422      then RDStation::Error::UnprocessableEntity
      when 500      then RDStation::Error::InternalServerError
      when 501      then RDStation::Error::NotImplemented
      when 502      then RDStation::Error::BadGateway
      when 503      then RDStation::Error::ServiceUnavailable
      when 500..599 then RDStation::Error::ServerError
      else
        RDStation::Error::UnknownError
      end
    end

    def array_of_errors
      error_formatter.to_array.map do |error|
        error.merge(additional_error_attributes)
      end
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
        'http_status' => response.code,
      }
    end
  end
end
