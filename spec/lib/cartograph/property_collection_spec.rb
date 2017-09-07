require 'spec_helper'

describe Cartograph::PropertyCollection do
  describe '#filter_by_scope' do
    it 'only returns properties with a certain scope attached' do
      collection = Cartograph::PropertyCollection.new
      collection << Cartograph::Property.new(:hello, scopes: [:read, :create])
      collection << Cartograph::Property.new(:id, scopes: [:read])

      filtered = collection.filter_by_scope(:create)
      expect(filtered.size).to be(1)
      expect(filtered.first.name).to eq(:hello)
    end
  end
end
