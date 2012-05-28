require "active_support/dependencies"
require "datajam/datacard/core_ext/array"
require "datajam/datacard/version"
require "datajam/datacard/magic_attrs"
require "datajam/datacard/api_mapping"
require "datajam/datacard/engine"

require "datajam/mappings/influence_explorer"

module Datajam
  module Datacard
    mattr_accessor :app_root

    def self.setup
      yield self if block_given?
    end

    def self.install_required?
      false
    end

    def self.installed?
      true
    end
  end
end
