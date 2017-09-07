# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cartograph/version'

Gem::Specification.new do |spec|
  spec.name          = "cartograph"
  spec.version       = Cartograph::VERSION
  spec.authors       = ["Robert Ross"]
  spec.email         = ["engineering@digitalocean.com", "rross@digitalocean.com", "ivan@digitalocean.com"]
  spec.summary       = %q{Cartograph makes it easy to generate and convert JSON. It's intention is to be used for API clients.}
  spec.description   = %q{Cartograph makes it easy to generate and convert JSON. It's intention is to be used for API clients.}
  spec.homepage      = "https://github.com/digitaloceancloud/cartograph"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "pry"
end
