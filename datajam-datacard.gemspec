# -*- ruby -*-
require File.expand_path('../lib/datajam/datacard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sunlight Labs", "Chris Kowalik"]
  gem.email         = ["chris@nu7hat.ch"]
  gem.description   = File.open(File.expand_path("../README.md", __FILE__)).read rescue nil
  gem.summary       = %q{Datacard engine for Datajam}
  gem.homepage      = "http://datajam.org"
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "datajam-datacard"
  gem.require_paths = ["lib"]
  gem.version       = Datajam::Datacard::VERSION

  # Dependencies
  gem.add_dependency "faraday"
  gem.add_dependency "json"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mocha"
end
