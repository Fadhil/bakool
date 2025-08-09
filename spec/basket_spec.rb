require "basket"

describe Basket do
  context "without a given catalogue" do
    it "creates a basket with a catalogue of default products" do
      basket = Basket.new
      expect(basket.catalogue.products.count).to eq(3)
      expect(basket.catalogue.products[0].name).to eq("Red Widget")
      expect(basket.catalogue.products[0].code).to eq("R01")
      expect(basket.catalogue.products[0].price).to eq(32.95)
      expect(basket.catalogue.products[1].name).to eq("Green Widget")
      expect(basket.catalogue.products[1].code).to eq("G01")
      expect(basket.catalogue.products[1].price).to eq(24.95)
      expect(basket.catalogue.products[2].name).to eq("Blue Widget")
      expect(basket.catalogue.products[2].code).to eq("B01")
      expect(basket.catalogue.products[2].price).to eq(7.95)
    end
  end

  describe ".add" do
    context "without a valid product code" do
      it "raises an error" do
        basket = Basket.new
        expect { basket.add("invalid") }.to raise_error(InvalidProductCodeError)
      end
    end

    context "with a valid product code" do
      it "adds the product to the basket" do
        basket = Basket.new
        basket.add("R01")
        expect(basket.items.count).to eq(1)
        expect(basket.items.first.code).to eq("R01")
      end

      it "adds multiple products to the basket" do
        basket = Basket.new
        basket.add("R01")
        basket.add("G01")
        expect(basket.items.count).to eq(2)
        expect(basket.items.first.code).to eq("R01")
        expect(basket.items[1].code).to eq("G01")
      end

      it "adds multiple products of the same type to the basket" do
        basket = Basket.new
        basket.add("R01")
        basket.add("G01")
        basket.add("G01")
        expect(basket.items.count).to eq(3)
        expect(basket.items.first.code).to eq("R01")
        expect(basket.items[1].code).to eq("G01")
        expect(basket.items[2].code).to eq("G01")
      end
    end
  end

  describe ".total" do
    context "with no items in the basket" do
      it "returns 0" do
        basket = Basket.new
        expect(basket.total).to eq(0)
      end
    end

    context "with items in the basket" do
      it "returns the total price of the basket" do
        basket = Basket.new
        basket.add("R01")
        basket.add("G01")
        expect(basket.total).to eq(57.9)
      end
    end
  end
end
