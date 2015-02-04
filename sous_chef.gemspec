# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sous_chef/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name             = "sous_chef"
  gem.version          = SousChef::VERSION

  gem.authors          = ["Martin Emde", "Brian Donovan"]
  gem.email            = ["memde@engineyard.com", "bdonovan@engineyard.com"]
  gem.summary          = "Chef's prep-cook"
  gem.description      = 'Create bash scripts using a simple chef-like syntax'
  gem.homepage         = "http://github.com/engineyard/sous_chef"
  gem.license          = "MIT"

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec/*`.split("\n")
  gem.extra_rdoc_files = %w[ LICENSE README.rdoc ]
  gem.require_paths    = [ "lib" ]

  gem.add_development_dependency 'rake',  '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 1.3'
end
