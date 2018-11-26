require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::Default do
  describe '#raise_error' do
    let(:errors) { [{ 'error_message' => 'Error Message' }] }
    let(:default_error) { described_class.new(errors) }

    it 'raises the received error' do
      expect do
        default_error.raise_error
      end.to raise_error(RDStation::Error::Default, errors.first['error_message'])
    end
  end
end
