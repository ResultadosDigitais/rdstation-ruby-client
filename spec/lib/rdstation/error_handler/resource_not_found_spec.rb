require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::ResourceNotFound do
  describe '#raise_error' do

    subject(:resource_not_found_error) { described_class.new(errors) }

    context 'when there is a resource not found error' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'RESOURCE_NOT_FOUND'
          }
        ]
      end

      it 'raises an ResourceNotFound error' do
        expect do
          resource_not_found_error.raise_error
        end.to raise_error(RDStation::Error::ResourceNotFound, 'Error Message')
      end
    end

    context 'when none of the errors are resource not found errors' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'RANDOM_ERROR_TYPE'
          },
          {
            'error_message' => 'Another Error Message',
            'error_type' => 'ANOTHER_RANDOM_ERROR_TYPE'
          }
        ]
      end

      it 'does not raise an ResourceNotFound error' do
        result = resource_not_found_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an ResourceNotFound error' do
        result = resource_not_found_error.raise_error
        expect(result).to be_nil
      end
    end
  end
end
