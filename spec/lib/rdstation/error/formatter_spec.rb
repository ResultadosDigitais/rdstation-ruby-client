require 'spec_helper'

RSpec.describe RDStation::Error::Formatter do
  describe '#to_array' do
    context 'when receives a flat hash of errors' do
      let(:api_response) do
        OpenStruct.new(
          code: 400,
          headers: { 'content-type' => ['application/json; charset=utf-8'] },
          body: {
            'errors' => {
              'error_type' => 'CONFLICTING_FIELD',
              'error_message' => 'The payload contains an attribute that was used to identify the lead'
            }
          }.to_json
        )
      end

      let(:error_formatter) { described_class.new(api_response) }

      let(:expected_result) do
        [
          {
            'error_type' => 'CONFLICTING_FIELD',
            'error_message' => 'The payload contains an attribute that was used to identify the lead',
            'status' => 400,
            'headers' => { 'content-type' => ['application/json; charset=utf-8'] }
          }
        ]
      end

      it 'returns an array of errors including the status code and headers' do
        result = error_formatter.to_array
        expect(result).to eq(expected_result)
      end
    end

    context 'when receives a hash of arrays of errors' do
      let(:api_response) do
        OpenStruct.new(
          code: 400,
          headers: { 'content-type' => ['application/json; charset=utf-8'] },
          body: {
            'errors' => {
              'name' => [
                {
                  'error_type' => 'MUST_BE_STRING',
                  'error_message' => 'Name must be string.'
                }
              ]
            }
          }.to_json
        )
      end

      let(:error_formatter) { described_class.new(api_response) }

      let(:expected_result) do
        [
          {
            'error_type' => 'MUST_BE_STRING',
            'error_message' => 'Name must be string.',
            'path' => 'body.name',
            'status' => 400,
            'headers' => { 'content-type' => ['application/json; charset=utf-8'] }
          }
        ]
      end

      it 'returns an array of errors including the status code and headers' do
        result = error_formatter.to_array
        expect(result).to eq(expected_result)
      end
    end

    context 'when receives an array of errors' do
      let(:api_response) do
        OpenStruct.new(
          code: 400,
          headers: { 'content-type' => ['application/json; charset=utf-8'] },
          body: {
            'errors' =>
            [
              {
                'error_type' => 'CANNOT_BE_NULL',
                'error_message' => 'Cannot be null.',
                'path' => 'body.client_secret'
              }
            ]
          }.to_json
        )
      end

      let(:error_formatter) { described_class.new(api_response) }

      let(:expected_result) do
        [
          {
            'error_type' => 'CANNOT_BE_NULL',
            'error_message' => 'Cannot be null.',
            'path' => 'body.client_secret',
            'status' => 400,
            'headers' => { 'content-type' => ['application/json; charset=utf-8'] }
          }
        ]
      end

      it 'returns an array of errors including the status code and headers' do
        result = error_formatter.to_array
        expect(result).to eq(expected_result)
      end
    end

    context 'when the received response does not contains errors' do
      let(:api_response) do
        OpenStruct.new(
          code: 400,
          headers: { 'content-type' => ['application/json; charset=utf-8'] },
          body: { 'name' => 'Contact Name' }.to_json
        )
      end

      it 'raises an error' do
        expect do
          described_class.new(api_response)
        end.to raise_error(ArgumentError, "'api_response' does not seem to be an error response.")
      end
    end
  end
end
