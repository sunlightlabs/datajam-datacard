module Datajam
  module Datacard
    module APIMapping
      # Internal: Represents single API field. It contains all the 
      # settings related to it, like title, help text, kind, placeholder 
      # or validations.
      class Field < Definition
        attr_magic :type
        attr_magic :placeholder
        attr_magic :validate
        attr_magic :options
        attr_magic :prompt

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
      end
    end
  end
end
