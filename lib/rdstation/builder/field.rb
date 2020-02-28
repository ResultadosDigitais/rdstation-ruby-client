# frozen_string_literal: true

module RDStation
  class Builder
    # More info: https://developers.rdstation.com/pt-BR/reference/fields#methodPostDetails
    class Field
      DATA_TYPES = %w(STRING INTEGER BOOLEAN STRING[]).freeze
      PRESENTATION_TYPES = %w[TEXT_INPUT TEXT_AREA URL_INPUT PHONE_INPUT
                              EMAIL_INPUT CHECK_BOX NUMBER_INPUT COMBO_BOX RADIO_
                              BUTTON MULTIPLE_CHOICE].freeze

      REQUIRED_FIELDS = %w[api_identifier data_type presentation_type label name].freeze

      def initialize(api_identifier)
        raise 'api_identifier required' unless api_identifier

        @values = {}
        @values['api_identifier'] = api_identifier
      end

      def data_type(data_type)
        raise 'Not valid data_type' unless DATA_TYPES.include? data_type

        @values['data_type'] = data_type
      end

      def presentation_type(presentation_type)
        unless PRESENTATION_TYPES.include? presentation_type
          raise 'Not valid presentation_type'
        end

        @values['presentation_type'] = presentation_type
        end

      def label(language, label)
        @values['label'] = { language.to_s => label }
      end

      def name(language, name)
        @values['name'] = { language.to_s => name }
      end

      def build
        if REQUIRED_FIELDS.any? { |field| @values[field].nil? }
          raise 'Required fields are missing'
        end

        @values
      end
    end
  end
end
