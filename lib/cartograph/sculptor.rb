module Cartograph
  class Sculptor
    attr_reader :object, :map

    def initialize(object, map)
      @object = object
      @map = map
    end

    def properties
      map.properties
    end

    # Set this to pass in an object to extract into. Must
    # @param object must be of the same class as the map#mapping
    def sculpted_object=(object)
      raise ArgumentError unless object.is_a?(map.mapping)

      @sculpted_object = object
    end

    def sculpt(scope = nil)
      return unless @object

      scoped_properties = scope ? properties.filter_by_scope(scope) : properties

      attributes = scoped_properties.each_with_object({}) do |property, h|
        h[property.name] = property.value_from(object, scope)
      end

      return map.mapping.new(attributes) unless @sculpted_object

      attributes.each do |name, val|
        @sculpted_object[name] = val
      end

      @sculpted_object
    end
  end
end
