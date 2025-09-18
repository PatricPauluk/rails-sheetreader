require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validações' do
    let(:product) { Product.new(name: 'Test Product', price: 9.99, quantity: 10) }

    it 'é válido com atributos válidos' do
      expect(product).to be_valid
    end

    context 'name' do
      it 'é inválido sem um nome' do
        product.name = nil
        expect(product).to_not be_valid
        expect(product.errors[:name]).to include("can't be blank")
      end
    end

    context 'price' do
      it 'é inválido sem um preço' do
        product.price = nil
        expect(product).to_not be_valid
        expect(product.errors[:price]).to include("can't be blank")
      end

      it 'é inválido com preço negativo' do
        product.price = -1
        expect(product).to_not be_valid
        expect(product.errors[:price]).to include('must be greater than or equal to 0')
      end
    end

    context 'quantity' do
      it 'é inválido sem uma quantidade' do
        product.quantity = nil
        expect(product).to_not be_valid
        expect(product.errors[:quantity]).to include("can't be blank")
      end

      it 'é inválido com quantidade não inteira' do
        product.quantity = 1.5
        expect(product).to_not be_valid
        expect(product.errors[:quantity]).to include('must be an integer')
      end
    end
  end
end
