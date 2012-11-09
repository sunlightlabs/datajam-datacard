module Datajam
  module Datacard
    module APIMapping
      # Internal: Represents single API field. It contains all the
      # settings related to it, like title, help text, kind, placeholder
      # or validations.
      class InputField < Definition
        attr_magic :type
        attr_magic :placeholder
        attr_magic :options
        attr_magic :prompt
        attr_magic :default
        attr_reader :validators

        def initialize(name, options, &block)
          @validators = []
          super
        end

        # Public: Extended setter for type value. It also accepts second
        # parameter - a hash with options which will be merged to existing
        # definition options.
        def type(*args)
          args_s = args.size
          raise ArgumentError.new("wrong number of arguments") if args_s > 2
          args.last.each { |key,val| send("#{key}=", val) } if args_s == 2
          @type = args.first if args_s > 0
          @type
        end

        # Public: Sets a value setter proc, but only once
        def value_setter(&block)
          if block_given?
            @value_setter ||= block
          else
            @value_setter ||= Proc.new {|val| val }
          end
          @value_setter
        end

        # Public: Sets a validator proc for the input value.
        # Runs after value_setter, interrupts request if errors are raised
        def validate(&block)
          if block_given?
            @validators << block
          end
        end
      end
    end
  end
end
