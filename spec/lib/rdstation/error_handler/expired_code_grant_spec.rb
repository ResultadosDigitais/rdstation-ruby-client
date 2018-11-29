require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::ExpiredCodeGrant do
  describe '#raise_error' do

    subject(:expired_code_grant_error) { described_class.new(errors) }

    context 'when there is an expired code grant error' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'EXPIRED_CODE_GRANT'
          }
        ]
      end

      it 'raises an ExpiredCodeGrant error' do
        expect do
          expired_code_grant_error.raise_error
        end.to raise_error(RDStation::Error::ExpiredCodeGrant, 'Error Message')
      end
    end

    context 'when none of the errors are expired code grant errors' do
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

      it 'does not raise an ExpiredCodeGrant error' do
        result = expired_code_grant_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an ExpiredCodeGrant error' do
        result = expired_code_grant_error.raise_error
        expect(result).to be_nil
      end
    end
  end
end
