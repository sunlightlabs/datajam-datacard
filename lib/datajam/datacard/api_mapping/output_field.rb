module Datajam
  module Datacard
    module APIMapping
      # Internal: Represents single API field. It contains all the
      # settings related to it, like title, help text, kind, placeholder
      # or validations.
      class OutputField < Definition

        # # Internal: Sets a value reader proc, but only once
        def value_reader(&block)
          if block_given?
            @value_reader ||= block
          else
            @value_reader ||= Proc.new {|val| val }
          end
          @value_reader
        end
      end
    end
  end
end
