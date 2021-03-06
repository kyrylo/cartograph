require 'spec_helper'

describe Cartograph::Sculptor do
  describe '#initialize' do
    it 'initializes with a hash and map' do
      hash = {}
      map = double('im a map')

      sculptor = Cartograph::Sculptor.new(hash, map)

      expect(sculptor.object).to be(hash)
      expect(sculptor.map).to be(map)
    end
  end

  describe '#sculpted_object=' do
    context 'objects that are not the mapping class' do
      it 'raises an error' do
        hash = {}
        map = double(Cartograph::Map, mapping: Hash)

        sculptor = Cartograph::Sculptor.new(hash, map)

        expect {
          sculptor.sculpted_object = ""
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#sculpt' do
    let(:map) { Cartograph::Map.new }
    let(:object) { { 'id' => 343, 'name' => 'Guilty Spark', 'email_address' => 'guilty@bungie.net' } }

    it 'returns nil if the object in nil' do
      sculptor = Cartograph::Sculptor.new(nil, map)
      expect(sculptor.sculpt).to be_nil
    end

    context 'without a scope' do
      before do
        map.mapping DummyUser
        map.property :id, scopes: [:read]
        map.property :name, scopes: [:read, :create]
        map.property :email, scopes: [:read, :create], key: 'email_address'
      end

      it 'returns a coerced user' do
        sculptor = Cartograph::Sculptor.new(object, map)
        sculpted = sculptor.sculpt

        expect(sculpted).to be_kind_of(DummyUser)
        expect(sculpted.id).to eq(object['id'])
        expect(sculpted.name).to eq(object['name'])
        expect(sculpted.email).to eq(object['email_address'])
      end

      it 'sculpts into a provided object' do
        sculptor = Cartograph::Sculptor.new(object, map)
        dummy = DummyUser.new
        sculptor.sculpted_object = dummy
        sculpted = sculptor.sculpt

        expect(sculpted).to eq(dummy)
      end
    end

    context 'with a scope' do
      before do
        map.mapping DummyUser
        map.property :id, scopes: [:read]
        map.property :name, scopes: [:create]
      end

      it 'returns a coerced user' do
        sculptor = Cartograph::Sculptor.new(object, map)
        sculpted = sculptor.sculpt(:read)

        expect(sculpted).to be_kind_of(DummyUser)
        expect(sculpted.id).to eq(object['id'])
        expect(sculpted.name).to be_nil
      end

      context 'for nested properties' do
        let(:object) { super().merge('comment' => { 'id' => 123, 'text' => 'hello' }) }

        before do
          map.property :comment, scopes: [:read] do
            mapping DummyComment

            property :id, scopes: [:read]
            property :text, scopes: [:create]
          end
        end

        it 'returns the nested objects with scoped properties set' do
          sculptor = Cartograph::Sculptor.new(object, map)
          sculpted = sculptor.sculpt(:read)

          expect(sculpted.comment).to be_kind_of(DummyComment)
          expect(sculpted.comment.id).to eq(123)
          expect(sculpted.comment.text).to be_nil
        end
      end
    end
  end
end
