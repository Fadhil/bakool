# frozen_string_literal: true

require "product"

# rubocop:disable Metrics/BlockLength
describe Product do
  context "with name, code and price" do
    it "initialises a product with the given name, code and price" do
      product = Product.new("Product 1", "P1", 100)
      expect(product.name).to eq("Product 1")
      expect(product.code).to eq("P1")
      expect(product.price).to eq(100)
    end

    it "also saves the price in cents" do
      product = Product.new("Product 1", "P1", 100)
      expect(product.price_in_cents).to eq(10_000)
    end
  end

  context "without a name or code" do
    it "raises an error" do
      expect { Product.new(nil, "P1", 100) }.to raise_error(ArgumentError)
      expect { Product.new("Product 1", nil, 100) }.to raise_error(ArgumentError)
    end
  end

  context "with a negative price" do
    it "raises an error" do
      expect { Product.new("Product 1", "P1", -100) }.to raise_error(ArgumentError)
    end
  end

  context "without a price" do
    it "defaults to 0" do
      product = Product.new("Product 1", "P1")
      expect(product.price).to eq(0)
    end
  end
end
# rubocop:enable Metrics/BlockLength
