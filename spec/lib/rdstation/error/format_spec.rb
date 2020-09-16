require 'spec_helper'

RSpec.describe RDStation::Error::Format do
  describe '#format' do
    subject(:error_format) { described_class.new(errors) }

    context 'when receives a flat hash of errors' do
      let(:errors) do
        {
          'error_type' => 'CONFLICTING_FIELD',
          'error_message' => 'The payload contains an attribute that was used to identify the lead'
        }
      end

      it 'returns the FLAT_HASH format' do
        result = error_format.format
        expect(result).to eq(RDStation::Error::Format::FLAT_HASH)
      end
    end

    context 'when receives a hash of arrays of errors' do
      let(:errors) do
        {
          'name' => [
            {
              'error_type' => 'MUST_BE_STRING',
              'error_message' => 'Name must be string.'
            }
          ]
        }
      end

      it 'returns the HASH_OF_ARRAYS format' do
        result = error_format.format
        expect(result).to eq(RDStation::Error::Format::HASH_OF_ARRAYS)
      end
    end

    context 'when receives an array of errors' do
      let(:errors) do
        [
          {
            'error_type' => 'CANNOT_BE_NULL',
            'error_message' => 'Cannot be null.',
            'path' => 'body.client_secret'
          }
        ]
      end

      it 'returns the ARRAY_OF_HASHES format' do
        result = error_format.format
        expect(result).to eq(RDStation::Error::Format::ARRAY_OF_HASHES)
      end
    end

    context 'when receives a mixed type of errors' do
      let(:errors) do
        {
          'label': {
            'pt-BR': [
              {
                'error_type': 'CANNOT_BE_BLANK',
                'error_message': 'cannot be blank'
              }
            ]
          },
          'api_identifier': [
            {
              'error_type': 'CANNOT_BE_BLANK',
              'error_message': 'cannot be blank'
            }
          ]
        }
      end

      it 'returns the HASH_OF_MULTIPLE_TYPES format' do
        result = error_format.format
        expect(result).to eq(RDStation::Error::Format::HASH_OF_MULTIPLE_TYPES)
      end
    end

    context 'when receives a hash of hashes errors' do
      let(:errors) do
        {
          label: {
            'pt-BR': [
              {
                'error_type': 'CANNOT_BE_BLANK',
                'error_message': 'cannot be blank'
              }
            ]
          }
        }
      end

      it 'returns the HASH_OF_MULTILINGUAL format' do
        result = error_format.format
        expect(result).to eq(RDStation::Error::Format::HASH_OF_HASHES)
      end
    end

    context 'when receives a single hash with error' do
      let(:errors) do
        {
          'error' => "'lead_limiter' rate limit exceeded for 86400 second(s) period for key ...",
          'max' => 24,
          'usage' => 55,
          'remaining_time' => 20745,
        }
      end

      it 'returns the SINGLE_HASH format' do
        result = error_format.format
        expect(result).to eq(RDStation::Error::Format::SINGLE_HASH)
      end

    end
  end
end
