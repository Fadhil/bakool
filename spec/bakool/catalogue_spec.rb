# frozen_string_literal: true

require "bakool"

# rubocop:disable Metrics/BlockLength
describe Bakool::Catalogue do
  describe "without any products" do
    it "initializes with an empty array" do
      catalogue = Bakool::Catalogue.new
      expect(catalogue.products).to eq([])
    end

    it "can add a product" do
      catalogue = Bakool::Catalogue.new
      catalogue.add_product(Bakool::Product.new("Product 1", "P1", 100))
      expect(catalogue.products.first.name).to eq("Product 1")
      expect(catalogue.products.first.code).to eq("P1")
      expect(catalogue.products.first.price).to eq(100)
    end
  end

  describe "::default_catalogue" do
    it "returns an array of default products" do
      catalogue = Bakool::Catalogue.default_catalogue
      expect(catalogue.products.count).to eq(3)
      expect(catalogue.products[0].name).to eq("Red Widget")
      expect(catalogue.products[0].code).to eq("R01")
      expect(catalogue.products[0].price).to eq(32.95)
      expect(catalogue.products[1].name).to eq("Green Widget")
      expect(catalogue.products[1].code).to eq("G01")
      expect(catalogue.products[1].price).to eq(24.95)
      expect(catalogue.products[2].name).to eq("Blue Widget")
      expect(catalogue.products[2].code).to eq("B01")
      expect(catalogue.products[2].price).to eq(7.95)
    end
  end
end
# rubocop:enable Metrics/BlockLength
