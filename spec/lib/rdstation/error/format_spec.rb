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
  end
end
