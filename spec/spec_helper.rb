require File.expand_path('../../config/environment', __FILE__)
require 'rspec'
require 'mocha'
require 'datajam/datacard'

RSpec.configure do |conf|
  conf.mock_with :mocha

  conf.before(:suite) do
    load File.expand_path('../datajam/db/seeds.rb', __FILE__)
    Datajam::Datacard::Engine.load_seed
  end
end
