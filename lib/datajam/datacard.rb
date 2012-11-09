require "active_support/dependencies"

require "datajam/datacard/core_ext/array"
require "datajam/datacard/core_ext/float"
require "datajam/datacard/core_ext/object"
require "datajam/datacard/version"
require "datajam/datacard/magic_attrs"
require "datajam/datacard/api_mapping"
require "datajam/datacard/engine"

module Datajam
  module Datacard
    mattr_accessor :app_root

    def self.setup
      yield self if block_given?
    end

    def self.install_required?
      true
    end

    def self.installed?
      Datajam::Settings[:'datajam-datacard'].any?
    end
  end
end
