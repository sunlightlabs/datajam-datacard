module Datajam
  module Datacard
    module MagicAttrs
      # Public: Defines magically accessible attributes
      #
      # names - An Array of attribute names.
      #
      def attr_magic(*names)
        names.each { |name| define_magic_attr(name) }
      end

      # Internal: Defines magically accessible attribute.
      #
      # name - A String or Symbol name of the attribute
      #
      def define_magic_attr(name)
        define_method name do |*attrs|
          raise ArgumentError.new("wrong number of arguments") if attrs.size > 1
          send("#{name}=", attrs.first) if attrs.size == 1
          instance_variable_get("@#{name}")
        end

        attr_writer name
      end
    end
  end
end
