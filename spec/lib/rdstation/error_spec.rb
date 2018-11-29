require 'spec_helper'

RSpec.describe RDStation::Error do
  describe '.new' do
    context 'with a valid details hash' do
      let(:error_details) { { 'error_message' => 'message', 'error_type' => 'ERROR_TYPE' } }
      let(:result) { described_class.new(error_details) }

      it 'creates a new instance of errors with details' do
        expect(result.details).to eq(error_details)
      end
    end

    context 'with an invalid details hash' do
      let(:error_details) { { 'error_type' => 'ERROR_TYPE' } }

      it 'raises an invalid argument error' do
        expect do
          described_class.new(error_details)
        end.to raise_error(ArgumentError, 'The details hash must contain an error message')
      end
    end
  end
end
