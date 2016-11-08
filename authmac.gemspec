# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'authmac/version'

Gem::Specification.new do |gem|
  gem.name          = "authmac"
  gem.version       = Authmac::VERSION
  gem.authors       = ["Marten Veldthuis"]
  gem.email         = ["marten@veldthuis.com"]
  gem.licenses      = ['MIT']
  gem.description   = 'Single Sign-On implementation based on HMAC.'
  gem.summary       = 'Single Sign-On implementation based on HMAC.'
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_development_dependency "rake", "~> 10.0.3"
  gem.add_development_dependency "rspec", "~> 3.0.0.beta1"
end
