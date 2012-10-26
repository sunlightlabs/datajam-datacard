require 'active_support/inflector'

module Datajam
  module Datacard
    module APIMapping
      # Internal: Base class for API mapping definitions (eg. settings or
      # fields/params).
      class Definition
        extend Datajam::Datacard::MagicAttrs

        attr_reader :name
        attr_writer :label
        attr_magic  :help_text

        # Internal: Constructor.
        #
        # name    - A String or Symbol name of the field.
        # options - An optional Hash with field settings.
        # block   - An optional block that can be used to customize definition's
        #           behavior or attributes.
        #
        def initialize(name, options = {}, &block)
          @name = name
          options.each { |key, value| send("#{key}=", value)}
          instance_eval(&block) if block_given?
        end

        # Public: attr_magic-like accessor for label, returns titleized name if
        #         no label is defined
        #
        def label(*attrs)
          raise ArgumentError.new("wrong number of arguments") if attrs.size > 1
          send("label=", attrs.first) if attrs.size == 1
          instance_variable_get('@label') || @name.to_s.titleize
        end
      end
    end
  end
end
