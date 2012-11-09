# -*- ruby -*-
require File.expand_path('../lib/datajam/datacard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Drinkard", "Chris Kowalik", "Sunlight Foundation"]
  gem.email         = "ddrinkard@sunlightfoundation.com"
  gem.description   = File.open(File.expand_path("../README.md", __FILE__)).read rescue nil
  gem.summary       = %q{Datacard engine for Datajam}
  gem.homepage      = "http://datajam.org"
  gem.files         = Dir["{app,config,db,lib,public}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "datajam-datacard"
  gem.require_paths = ["lib"]
  gem.version       = Datajam::Datacard::VERSION

  # Dependencies
  gem.add_dependency "faraday"
  gem.add_dependency "faraday_middleware"
  gem.add_dependency "hashie"
  gem.add_dependency "json"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "vcr"
  gem.add_development_dependency "fakeweb"
  gem.add_development_dependency "fuubar"
end
