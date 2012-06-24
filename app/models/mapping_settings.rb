class MappingSettings
  include Mongoid::Document

  field :settings,   type: Hash, default: {}
  field :mapping_id, type: String
end
