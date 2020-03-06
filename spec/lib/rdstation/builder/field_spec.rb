# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RDStation::Builder::Field do
  def valid_builder
    described_class.new('cf_identifier')
  end

  describe 'when create a builder' do
    context 'valid' do
      let(:initial_parameters) do
        'cf_api_identifier'
      end

      let(:builder) { described_class.new(initial_parameters) }

      let(:expected_result) do
        {
          'api_identifier' => 'cf_api_identifier',
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
    context 'invalid' do
      it 'using invalid api_identifier ' do
        expect { described_class.new('identifier') }.to raise_error(
          'api_identifier is not in a valid format, need start with "cf_"'
        )
      end

      it 'using invalid data_type ' do
        expect { valid_builder.data_type('type') }.to raise_error(
          'Not valid data_type - ["STRING", "INTEGER", "BOOLEAN", "STRING[]"]'
        )
      end

      it 'using invalid presentation_type ' do
        expect { valid_builder.presentation_type('type') }.to raise_error(
          'Not valid presentation_type - ["TEXT_INPUT", "TEXT_AREA", "URL_INPUT", "PHONE_INPUT", "EMAIL_INPUT", "CHECK_BOX", "NUMBER_INPUT", "COMBO_BOX", "RADIO_BUTTON", "MULTIPLE_CHOICE"]'
        )
      end

      it 'without api_identifier' do
        expect { described_class.new(nil) }.to raise_error('api_identifier required')
      end

      it 'without required fields' do
        expect { valid_builder.build }.to raise_error(
          'Required fields are missing - ["data_type", "presentation_type", "label", "name"]'
        )
      end
    end
  end
end
