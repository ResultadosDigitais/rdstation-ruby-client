require 'spec_helper'

RSpec.describe RDStation::ErrorHandler do
  describe '#raise_errors' do
    subject(:error_handler) { described_class.new(error_response) }

    let(:array_of_errors) do
      [
        {
          'error_type' => 'ERROR_TYPE',
          'error_message' => 'Error Message',
          'headers' => { 'error' => 'header' },
          'http_status' => http_status,
          'body' => {
            'errors' => {
              'error_type' => 'ERROR_TYPE',
              'error_message' => 'Error Message'
            }
          }
        }
      ]
    end

    let(:error_response) do
      OpenStruct.new(
        code: http_status,
        headers: { 'error' => 'header' },
        body: {
          'errors' => {
            'error_type' => 'ERROR_TYPE',
            'error_message' => 'Error Message'
          }
        }.to_json
      )
    end

    context 'with an error 400' do
      let(:http_status) { 400 }

      let(:bad_request_handler) { instance_double(RDStation::ErrorHandler::BadRequest, raise_error: 'raised error') }

      before do
        allow(RDStation::ErrorHandler::BadRequest).to receive(:new).with(array_of_errors).and_return(bad_request_handler)
      end

      it 'calls the bad request error handler' do
        error_handler.raise_error
        expect(bad_request_handler).to have_received(:raise_error)
      end
    end

    context 'with an error 401' do
      let(:http_status) { 401 }

      let(:unauthorized_handler) { instance_double(RDStation::ErrorHandler::Unauthorized, raise_error: 'raised error') }

      before do
        allow(RDStation::ErrorHandler::Unauthorized).to receive(:new).with(array_of_errors).and_return(unauthorized_handler)
      end

      it 'calls the unauthorized error handler' do
        error_handler.raise_error
        expect(unauthorized_handler).to have_received(:raise_error)
      end
    end

    context 'with an error 403' do
      let(:http_status) { 403 }

      it 'raises a forbidden error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::Forbidden, 'Error Message')
      end
    end

    context 'with an error 404' do
      let(:http_status) { 404 }

      it 'raises a not found error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::NotFound, 'Error Message')
      end
    end

    context 'with an error 405' do
      let(:http_status) { 405 }

      it 'raises a method not allowed error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::MethodNotAllowed, 'Error Message')
      end
    end

    context 'with an error 406' do
      let(:http_status) { 406 }

      it 'raises a not acceptable error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::NotAcceptable, 'Error Message')
      end
    end

    context 'with an error 409' do
      let(:http_status) { 409 }

      it 'raises a conflict error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::Conflict, 'Error Message')
      end
    end

    context 'with an error 415' do
      let(:http_status) { 415 }

      it 'raises an unsupported media type error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::UnsupportedMediaType, 'Error Message')
      end
    end

    context 'with an error 422' do
      let(:http_status) { 422 }

      it 'raises an unprocessable entity error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::UnprocessableEntity, 'Error Message')
      end
    end

    context 'with an error 500' do
      let(:http_status) { 500 }

      it 'raises an internal server error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::InternalServerError, 'Error Message')
      end
    end

    context 'with an error 501' do
      let(:http_status) { 501 }

      it 'raises a not implemented error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::NotImplemented, 'Error Message')
      end
    end

    context 'with an error 502' do
      let(:http_status) { 502 }

      it 'raises a bad gateway error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::BadGateway, 'Error Message')
      end
    end

    context 'with an error 503' do
      let(:http_status) { 503 }

      it 'raises a service unavailable error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::ServiceUnavailable, 'Error Message')
      end
    end

    context 'with 5xx error' do
      let(:http_status) { 505 }

      it 'raises a server error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::ServerError, 'Error Message')
      end
    end

    context "when response body is not JSON-parseable" do
      let(:error_response) do
        OpenStruct.new(
          code: 502,
          headers: { 'error' => 'header' },
          body: '<html><body>HTML error response</body></html>'
        )
      end

      it 'raises the correct error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::BadGateway, '<html><body>HTML error response</body></html>')
      end
    end

    context 'with an unknown error' do
      let(:http_status) { 123 }

      it 'raises a unknown error' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::UnknownError, 'Error Message')
      end
    end
  end
end
