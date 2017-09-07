require 'spec_helper'

describe Cartograph::Artist do
  let(:map) { Cartograph::Map.new }
  let(:properties) { map.properties }

  describe '#initialize' do
    it 'initializes with an object and a map' do
      object     = double('object', name: 'hello')
      properties << Cartograph::Property.new(:name)

      artist = Cartograph::Artist.new(object, map)

      expect(artist.object).to be(object)
      expect(artist.map).to be(map)
    end
  end

  describe '#draw' do
    it 'returns a hash of mapped properties' do
      object     = double('object', hello: 'world')
      properties << Cartograph::Property.new(:hello)

      artist = Cartograph::Artist.new(object, map)
      masterpiece = artist.draw

      expect(masterpiece).to include('hello' => 'world')
    end

    it 'raises for a property that the object does not have' do
      class TestArtistNoMethod; end
      object = TestArtistNoMethod.new
      properties << Cartograph::Property.new(:bunk)
      artist = Cartograph::Artist.new(object, map)

      expect { artist.draw }.to raise_error(ArgumentError).with_message("#{object} does not respond to bunk, so we can't map it")
    end

    context 'for a property with a key set on it' do
      it 'returns the hash with the key set correctly' do
        object     = double('object', hello: 'world')
        properties << Cartograph::Property.new(:hello, key: :hola)

        artist = Cartograph::Artist.new(object, map)
        masterpiece = artist.draw

        expect(masterpiece).to include('hola' => 'world')
      end
    end

    context 'for filtered drawing' do
      it 'only returns the scoped properties' do
        object     = double('object', hello: 'world', foo: 'bar')
        properties << Cartograph::Property.new(:hello, scopes: [:create, :read])
        properties << Cartograph::Property.new(:foo, scopes: [:create])

        artist = Cartograph::Artist.new(object, map)
        masterpiece = artist.draw(:read)

        expect(masterpiece).to eq('hello' => 'world')
      end

      context 'on nested properties' do
        it 'only returns the nested properties within the same scope' do
          child = double('child', hello: 'world', foo: 'bunk')
          object = double('object', child: child)

          root_property = Cartograph::Property.new(:child, scopes: [:create, :read]) do
            property :hello, scopes: [:create]
            property :foo, scopes: [:read]
          end

          properties << root_property

          artist = Cartograph::Artist.new(object, map)
          masterpiece = artist.draw(:read)

          expect(masterpiece).to eq('child' => { 'foo' => child.foo })
        end
      end
    end

    context "with caching enabled" do
      let(:cacher) { double('cacher', fetch: { foo: 'cached-value' }) }
      let(:object) { double('object', foo: 'bar', cache_key: 'test-cache-key') }

      it "uses the cache fetch for values" do
        map.cache(cacher)
        map.cache_key { |obj, scope| obj.cache_key }
        map.property :foo

        artist = Cartograph::Artist.new(object, map)
        masterpiece = artist.draw

        expect(masterpiece).to eq(cacher.fetch)

        expect(cacher).to have_received(:fetch).with('test-cache-key')
      end

      it "uses the cache key for the object and scope" do
        called = double(call: 'my-cache')

        map.cache(cacher)
        map.cache_key { |obj, scope| called.call(obj, scope) }

        map.property :foo, scopes: [:read]

        artist = Cartograph::Artist.new(object, map)
        masterpiece = artist.draw(:read)

        expect(called).to have_received(:call).with(object, :read)
      end
    end
  end
end
