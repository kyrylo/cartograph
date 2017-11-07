require 'forwardable'

module Cartograph
  class PropertyCollection
    # When either of these methods is used with 'def_delegators' Ruby prints a
    # warning such as "possibly useless use of ... in void context". To work
    # around it, we skip them in 'def_delegators' and define them manually.
    WARNING_METHODS = %i[& * + - |]

    # Make this collection quack like an array
    # http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
    extend Forwardable
    def_delegators(
      :@collection,
      *(Array.instance_methods - Object.instance_methods - WARNING_METHODS)
    )

    def initialize(*)
      @collection = []
    end

    def filter_by_scope(scope)
      select do |property|
        property.scopes.include?(scope)
      end
    end

    def ==(other)
      each_with_index.inject(true) do |current_value, (property, index)|
        break unless current_value
        property == other[index]
      end
    end

    def &(other)
      @collection & other
    end

    def *(other)
      @collection * other
    end

    def +(other)
      @collection + other
    end

    def -(other)
      @collection + other
    end

    def |(other)
      @collection | other
    end
  end
end
