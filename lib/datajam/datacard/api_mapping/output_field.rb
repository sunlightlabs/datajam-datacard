module Datajam
  module Datacard
    module APIMapping
      # Internal: Represents single API field. It contains all the
      # settings related to it, like title, help text, kind, placeholder
      # or validations.
      class OutputField < Definition
        attr_magic :format
        attr_magic :locale

        # Public: Extended setter for format value. It also accepts an optional
        # locale parameter to localize currency formatting.
        def format(*args)
          args_s = args.size
          raise ArgumentError.new("wrong number of arguments") if args_s > 2
          args.last.each { |key,val| send("#{key}=", val) } if args_s == 2
          @format = args.first if args_s > 0
          @format
        end

        # Public: Sets a value reader proc, but only once
        def value_getter(&block)
          if block_given?
            @value_getter ||= block
          else
            @value_getter ||= Proc.new {|val| val }
          end
          @value_getter
        end
      end
    end
  end
end
