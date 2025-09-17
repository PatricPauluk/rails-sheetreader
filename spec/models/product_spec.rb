require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'é válido com todos os atributos' do
    product = Product.new(name: 'Test Product', price: 9.99, quantity: 10)
    expect(product).to be_valid
  end

  it 'é inválido sem um nome' do
    product = Product.new(name: nil, price: 9.99, quantity: 10)
    expect(product).to_not be_valid
  end

  it 'é inválido sem um preço' do
    product = Product.new(name: 'Test Product', price: nil, quantity: 10)
    expect(product).to_not be_valid
  end

  it 'é inválido sem uma quantidade' do
    product = Product.new(name: 'Test Product', price: 9.99, quantity: nil)
    expect(product).to_not be_valid
  end
end
