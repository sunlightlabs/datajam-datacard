ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec'
require 'vcr'
require 'mocha'
require 'database_cleaner'
require 'datajam/datacard'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f }

VCR.configure do |conf|
  conf.cassette_library_dir = 'spec/cassettes'
  conf.stub_with :fakeweb
  conf.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |conf|
  conf.include Mongoid::Matchers
  conf.extend VCR::RSpec::Macros
  conf.mock_with :mocha

  conf.before(:suite) do
    Rails.backtrace_cleaner.remove_silencers!
    DatabaseCleaner.strategy = :truncation
    load File.expand_path('../datajam/db/seeds.rb', __FILE__)
  end

  conf.before(:all) do
    @redis_db = REDIS
    @redis = Redis::Namespace.new(Rails.env.to_s, redis: @redis_db)
  end

  conf.before(:each) do
    DatabaseCleaner.start

    Datajam::Datacard::Engine.load_seed
  end

  conf.after(:each) do
    DatabaseCleaner.clean
    @redis_db.keys("#{Rails.env.to_s}*").each {|key| @redis_db.del(key)}
  end
end
