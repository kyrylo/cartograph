# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cartograph/version'

Gem::Specification.new do |spec|
  spec.name          = "cartograph"
  spec.version       = Cartograph::VERSION
  spec.authors       = ["Robert Ross", "Kyrylo Silin"]
  spec.email         = ["silin@kyrylo.org"]
  spec.summary       = %q{Cartograph makes it easy to generate and convert JSON. It's intention is to be used for API clients.}
  spec.description   = %q{Cartograph makes it easy to generate and convert JSON. It's intention is to be used for API clients.}
  spec.homepage      = "https://github.com/kyrylo/cartograph"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'pry', '~> 0'
end
