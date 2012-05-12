module Datajam
  module Datacard
    module APIMapping
      # Internal: Represents single API field. It contains all the 
      # settings related to it, like title, help text, kind, placeholder 
      # or validations.
      class Field
        extend Datajam::Datacard::MagicAttrs

        attr_magic :title
        attr_magic :help_text
        attr_magic :type
        attr_magic :placeholder
        attr_magic :validate
        attr_magic :options

        attr_reader :name

        # Internal: Constructor.
        #
        # name    - A String or Symbol name of the field.
        # title   - A String title of the field.
        # options - An optional Hash with field settings.
        # block   - An optional block that can be used to customize setting
        #           behavior or attributes.
        #
        def initialize(name, title, options = {}, &block)
          @name, self.title = name, title
          options.each { |key, value| send("#{key}=", value)}
          instance_eval(&block) if block_given?
        end
      end
    end
  end
end
