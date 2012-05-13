module Datajam
  module Datacard
    module APIMapping
      # Internal: Base class for API mapping definitions (eg. settings or
      # fields/params).
      class Definition
        extend Datajam::Datacard::MagicAttrs

        attr_reader :name
        attr_magic  :title
        attr_magic  :help_text

        # Internal: Constructor.
        #
        # name    - A String or Symbol name of the field.
        # title   - A String title of the field.
        # options - An optional Hash with field settings.
        # block   - An optional block that can be used to customize definition's
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
