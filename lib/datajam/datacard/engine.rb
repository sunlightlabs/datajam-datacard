require 'rails/engine'
require 'active_support/dependencies'

module Datajam
  module Datacard
    class Engine < Rails::Engine
      initializer "datajam_datacard.register_plugin" do
        Datajam.setup do |app|
          gemspec = File.expand_path("../../../../datajam-datacard.gemspec", __FILE__)
          app.plugins << Gem::Specification.load(gemspec)
        end
      end

      if Rails.env =~ /^(development|test)$/
        initializer "datajam_datacard.static_assets" do |app|
          app.middleware.use ::ActionDispatch::Static, "#{root}/public"
        end
      end
    end
  end
end
