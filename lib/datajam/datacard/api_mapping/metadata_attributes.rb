module Datajam
  module Datacard
    module APIMapping
      # Internal: Module provides mapping metadata attributes to base class
      # extended by API mappings.
      module MetadataAttributes
        extend Datajam::Datacard::MagicAttrs

        attr_magic :name
        attr_magic :version
        attr_magic :authors
        attr_magic :email
        attr_magic :homepage
        attr_magic :summary
        attr_magic :description
        attr_magic :base_uri
        attr_magic :data_type
      end
    end
  end
end
