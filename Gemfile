# -*- ruby -*-
source 'https://rubygems.org'
gemspec

eval File.read(File.expand_path('../spec/datajam/Gemfile', __FILE__)), binding

group :development, :test do
  gem 'datacard-influenceexplorer', path: File.expand_path('../../datacard-influenceexplorer', __FILE__), require: 'influence_explorer_mapping'
end
