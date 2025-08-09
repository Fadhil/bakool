# frozen_string_literal: true

require "bakool"

# rubocop:disable Metrics/BlockLength
describe Bakool::Basket do
  context "without a given catalogue" do
    it "creates a basket with a catalogue of default products" do
      basket = Bakool::Basket.new
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
        basket = Bakool::Basket.new
        expect { basket.add("invalid") }.to raise_error(Bakool::InvalidProductCodeError)
      end
    end

    context "with a valid product code" do
      it "adds the product to the basket" do
        basket = Bakool::Basket.new
        basket.add("R01")
        expect(basket.items.count).to eq(1)
        expect(basket.items.first.code).to eq("R01")
      end

      it "adds multiple products to the basket" do
        basket = Bakool::Basket.new
        basket.add("R01")
        basket.add("G01")
        expect(basket.items.count).to eq(2)
        expect(basket.items.first.code).to eq("R01")
        expect(basket.items[1].code).to eq("G01")
      end

      it "adds multiple products of the same type to the basket" do
        basket = Bakool::Basket.new
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
        basket = Bakool::Basket.new
        expect(basket.total).to eq(0)
      end
    end

    context "with one R01 item in the basket and no delivery charge rules" do
      it "applies no delivery charge (free delivery by default)" do
        basket = Bakool::Basket.new
        basket.add("R01")
        expect(basket.total).to eq(32.95)
      end
    end

    context "with one R01 and one G01 item in the basket and given delivery charge rules" do
      it "applies delivery charge accordingly" do
        delivery_charge_rule = Bakool::DeliveryChargeRule.new(
          lambda do |order_total|
            if order_total < 5000
              495
            elsif order_total < 9000
              295
            else
              0
            end
          end
        )
        basket = Bakool::Basket.new(delivery_charge_rule: delivery_charge_rule)
        basket.add("R01")
        basket.add("G01")
        expect(basket.total).to eq(60.85)
      end
    end

    context "with two R01 items in the basket and given discount rule for buy second R01 " \
            "items at half price and given delivery charge rules" do
      it "applies discount accordingly" do
        discount = Bakool::FiftyPercentOff2ndSameItemDiscount.new("R01")
        delivery_charge_rule = Bakool::DeliveryChargeRule.new(
          lambda do |order_total|
            if order_total < 5000
              495
            elsif order_total < 9000
              295
            else
              0
            end
          end
        )
        basket = Bakool::Basket.new(discount: discount, delivery_charge_rule: delivery_charge_rule)
        basket.add("R01")
        basket.add("R01")
        expect(basket.total).to eq(54.37)
      end
    end
  end

  context "with one B01 and one G01 in the basket and given discount rule for buy second " \
          "R01 items at half price and given delivery charge rules" do
    it "calculates the total correctly" do
      discount = Bakool::FiftyPercentOff2ndSameItemDiscount.new("R01")
      delivery_charge_rule = Bakool::DeliveryChargeRule.new(
        lambda do |order_total|
          if order_total < 5000
            495
          elsif order_total < 9000
            295
          else
            0
          end
        end
      )
      basket = Bakool::Basket.new(discount: discount, delivery_charge_rule: delivery_charge_rule)
      basket.add("B01")
      basket.add("G01")
      expect(basket.total).to eq(37.85)
    end
  end

  context "with B01, B01, R01, R01, R01 in the basket and given discount rule for buy " \
          "second R01 items at half price and given delivery charge rules" do
    it "calculates the total correctly" do
      discount = Bakool::FiftyPercentOff2ndSameItemDiscount.new("R01")
      delivery_charge_rule = Bakool::DeliveryChargeRule.new(
        lambda do |order_total|
          if order_total < 5000
            495
          elsif order_total < 9000
            295
          else
            0
          end
        end
      )
      basket = Bakool::Basket.new(discount: discount, delivery_charge_rule: delivery_charge_rule)
      basket.add("B01")
      basket.add("B01")
      basket.add("R01")
      basket.add("R01")
      basket.add("R01")
      expect(basket.total).to eq(98.27)
    end
  end
end
# rubocop:enable Metrics/BlockLength
