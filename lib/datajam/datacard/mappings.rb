module Datajam
  module Datacard
    # Returns list of registered mappings
    def self.mappings
      @mappings ||= Mappings.new
    end

    # Mappings is an extended array which is able to be rendered
    # by Datajam's `#table_for` helper.
    class Mappings < Array
      # Finds mapping by its class name and returns it.
      #
      # name - A string class name to be found.
      #
      # Returns found mapping or nil.
      def find_by_klass(name)
        find { |m| m.id == name }
      end

      def push(mapping)
        self << mapping unless self.include? mapping
      end
    end
  end
end
