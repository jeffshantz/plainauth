# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plainauth/version'

Gem::Specification.new do |gem|
  gem.name          = "plainauth"
  gem.version       = PlainAuth::VERSION
  gem.authors       = ["Jeff Shantz"]
  gem.email         = ["github@jeffshantz.com"]
  gem.description   = %q{A simple, drop-in replacement for ActiveModel::SecurePassword}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/jeffshantz/plainauth"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'appraisal', '~> 0.5.2'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.13.0'
end
