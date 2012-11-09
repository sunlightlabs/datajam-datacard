# -*- ruby -*-
source 'https://rubygems.org'
gemspec

eval File.read(File.expand_path('../spec/datajam/Gemfile', __FILE__)), binding

group :development, :test do
  gem 'datacard-influenceexplorer', git: 'https://github.com/sunlightlabs/datacard-influenceexplorer.git', require: 'influence_explorer_mapping'
end
