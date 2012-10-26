module Datajam
  module Datacard
    module APIMapping
      # Internal: Class defines stuff used to process responses from
      # the endpoints.
      class ResponseDefinition
        extend Datajam::Datacard::MagicAttrs

        attr_magic :data_type

        # Internal: Constructor.
        #
        # block   - An optional block that can be used to customize the response's
        #           behavior or attributes.
        #
        def initialize(&block)
          instance_eval(&block) if block_given?
        end

        # Public: Returns all defined response fields.
        def fields
          @fields ||= {}
        end

        # Public: Defines a response field for populating forms and formatting values.
        #
        # name    - A String name of the response field.
        # options - An optional Hash with field information.
        # block   - An optional block that can be used to customize the field's
        #           behavior or attributes.
        #
        # Example
        #
        #   field :amount, :label => "Contribution total" do
        #     value_reader do |val|
        #       number_to_currency(val)
        #     end
        #   end
        #
        # Returns new param definition.
        def field(name, options = {}, &block)
          fields[name] = OutputField.new(name, options, &block)
        end

        protected

      end
    end
  end
end
