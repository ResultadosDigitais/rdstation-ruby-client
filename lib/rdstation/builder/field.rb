# frozen_string_literal: true

module RDStation
  class Builder
    # More info: https://developers.rdstation.com/pt-BR/reference/fields#methodPostDetails
    class Field
      DATA_TYPES = %w(STRING INTEGER BOOLEAN STRING[]).freeze
      PRESENTATION_TYPES = %w[TEXT_INPUT TEXT_AREA URL_INPUT PHONE_INPUT
                              EMAIL_INPUT CHECK_BOX NUMBER_INPUT COMBO_BOX
                              RADIO_BUTTON MULTIPLE_CHOICE].freeze

      REQUIRED_FIELDS = %w[api_identifier data_type presentation_type label name].freeze

      def initialize(api_identifier)
        raise 'api_identifier required' unless api_identifier
        unless valid_identifier(api_identifier)
          raise 'api_identifier is not in a valid format, need start with "cf_"'
        end

        @values = {}
        @values['api_identifier'] = api_identifier
      end

      def data_type(data_type)
        raise "Not valid data_type - #{DATA_TYPES}" unless DATA_TYPES.include? data_type

        @values['data_type'] = data_type
      end

      def presentation_type(presentation_type)
        unless PRESENTATION_TYPES.include? presentation_type
          raise "Not valid presentation_type - #{PRESENTATION_TYPES}"
        end

        @values['presentation_type'] = presentation_type
      end

      def label(language, label)
        @values['label'] = { language.to_s => label }
      end

      def name(language, name)
        @values['name'] = { language.to_s => name }
      end

      def validation_rules(validation_rules)
        @values['validation_rules'] = validation_rules
      end

      def valid_options(valid_options)
        @values['valid_options'] = valid_options
      end

      def build
        empty_fields = REQUIRED_FIELDS.select { |field| @values[field].nil? }
        unless empty_fields.empty?
          raise "Required fields are missing - #{empty_fields}"
        end

        @values
      end

      private

      def valid_identifier(api_identifier)
        api_identifier.start_with? 'cf_'
      end
    end
  end
end
