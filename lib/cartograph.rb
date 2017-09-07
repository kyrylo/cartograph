require "cartograph/version"
require 'json'

module Cartograph
  autoload :DSL, 'cartograph/dsl'
  autoload :Map, 'cartograph/map'
  autoload :Property, 'cartograph/property'
  autoload :PropertyCollection, 'cartograph/property_collection'
  autoload :RootKey, 'cartograph/root_key'
  autoload :ScopeProxy, 'cartograph/scope_proxy'

  autoload :Artist, 'cartograph/artist'
  autoload :Sculptor, 'cartograph/sculptor'

  class << self
    attr_accessor :default_dumper
    attr_accessor :default_loader
    attr_accessor :default_cache
    attr_accessor :default_cache_key
  end

  self.default_dumper = JSON
  self.default_loader = JSON
end
