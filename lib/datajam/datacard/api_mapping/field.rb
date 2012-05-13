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
      end
    end
  end
end
