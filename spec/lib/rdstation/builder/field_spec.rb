# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RDStation::Builder::Field do
  context 'when create a builder' do
    let(:initial_parameters) do
      'api_identifier'
    end

    let(:builder) { described_class.new(initial_parameters) }

    let(:expected_result) do
      {
        'api_identifier' => 'api_identifier',
        'data_type' => 'STRING',
        'presentation_type' => 'TEXT_INPUT',
        'label' => { 'pt-BR' => 'My label' },
        'name' => { 'pt-BR' => 'My name' }
      }
    end

    it 'returns an hash of required values' do
      builder.label 'pt-BR', 'My label'
      builder.name 'pt-BR', 'My name'
      builder.data_type 'STRING'
      builder.presentation_type 'TEXT_INPUT'

      result = builder.build
      expect(result).to eq(expected_result)
    end
  end
end
