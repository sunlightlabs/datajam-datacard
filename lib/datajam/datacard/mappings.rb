module Datajam
  module Datacard
    # Mappings is an extended array which is able to be rendered
    # by Datajam's `#table_for` helper. 
    class Mappings < Array
      def options
        @options ||= {}
      end
    end
  end
end
