module Datajam
  module Datacard
    module DataCardsHelper
      def formatted_value_for_series_index(value, i, card)
        field = card.data_set.sourced.endpoint.response.fields.find_by_label(card.series[i]) rescue nil
        return value if field.nil?
        options = {}
        options[:locale] = field.locale if field.locale.present?
        case field.format
        when :currency
          return number_to_currency(value, options)
        else
          return value
        end
      end
    end
  end
end
