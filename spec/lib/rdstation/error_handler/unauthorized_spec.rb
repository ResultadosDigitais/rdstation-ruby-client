require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::Unauthorized do
  describe '#raise_error' do

    subject(:unauthorized_error) { described_class.new(errors) }

    context 'when there is an unauthorized error' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'UNAUTHORIZED'
          }
        ]
      end

      it 'raises an Unauthorized error' do
        expect do
          unauthorized_error.raise_error
        end.to raise_error(RDStation::Error::Unauthorized, 'Error Message')
      end
    end
  end
end
