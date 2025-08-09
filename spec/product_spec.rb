require "product"

describe Product do
  context "with name, code and price" do
    it "initialises a product with the given name, code and price" do
      product = Product.new("Product 1", "P1", 100)
      expect(product.name).to eq("Product 1")
      expect(product.code).to eq("P1")
      expect(product.price).to eq(100)
    end
  end
end
