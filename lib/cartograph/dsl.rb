module Cartograph
  module DSL
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def cartograph(&block)
        @cartograph_map ||= Map.new

        if block_given?
          block.arity > 0 ? block.call(@cartograph_map) : @cartograph_map.instance_eval(&block)
        end

        @cartograph_map
      end

      # Returns a hash representation of the object based on the mapping
      #
      # @param scope [Symbol] the scope of the mapping
      # @param object the object to be mapped
      # @return [Hash, Array]
      def hash_for(scope, object)
        drawn_object = Artist.new(object, @cartograph_map).draw(scope)
        prepend_root_key(scope, :singular, drawn_object)
      end

      # Returns a hash representation of the collection of objects based on the mapping
      #
      # @param scope [Symbol] the scope of the mapping
      # @params objects [Array] the array of objects to be mapped
      # @return [Hash, Array]
      def hash_collection_for(scope, objects)
        drawn_objects = objects.map do |object|
          Artist.new(object, @cartograph_map).draw(scope)
        end

        prepend_root_key(scope, :plural, drawn_objects)
      end

      def representation_for(scope, object, dumper = Cartograph.default_dumper)
        dumper.dump(hash_for(scope, object))
      end

      def represent_collection_for(scope, objects, dumper = Cartograph.default_dumper)
        dumper.dump(hash_collection_for(scope, objects))
      end

      def extract_single(content, scope, loader = Cartograph.default_loader)
        loaded = loader.load(content)

        retrieve_root_key(scope, :singular) do |root_key|
          # Reassign loaded if a root key exists
          loaded = loaded[root_key]
        end

        Sculptor.new(loaded, @cartograph_map).sculpt(scope)
      end

      def extract_into_object(object, content, scope, loader = Cartograph.default_loader)
        loaded = loader.load(content)

        retrieve_root_key(scope, :singular) do |root_key|
          # Reassign loaded if a root key exists
          loaded = loaded[root_key]
        end

        sculptor = Sculptor.new(loaded, @cartograph_map)
        sculptor.sculpted_object = object
        sculptor.sculpt(scope)
      end

      def extract_collection(content, scope, loader = Cartograph.default_loader)
        loaded = loader.load(content)

        retrieve_root_key(scope, :plural) do |root_key|
          # Reassign loaded if a root key exists
          loaded = loaded[root_key]
        end

        loaded.map do |object|
          object = { object.first => object[1] } if object.is_a?(Array)
          Sculptor.new(object, @cartograph_map).sculpt(scope)
        end
      end

      private
      def prepend_root_key(scope, plurality, payload)
        retrieve_root_key(scope, plurality) do |root_key|
          # Reassign drawed if a root key exists
          payload = { root_key => payload }
        end

        payload
      end

      def retrieve_root_key(scope, type, &block)
        if root_key = @cartograph_map.root_key_for(scope, type)
          yield root_key
        end
      end

    end
  end
end
