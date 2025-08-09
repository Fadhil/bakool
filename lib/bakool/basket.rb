# frozen_string_literal: true

# A shopping basket that can hold products and calculate totals with discounts and delivery charges
module Bakool
  class Basket
    attr_accessor :catalogue, :items, :delivery_charge_rule, :discount_rule, :discount

    def initialize(catalogue: Bakool::Catalogue.default_catalogue,
                   delivery_charge_rule: Bakool::DeliveryChargeRule.default_delivery_charge_rule,
                   discount: Bakool::DefaultDiscount.default_discount)
      @catalogue = catalogue
      @items = []
      @delivery_charge_rule = delivery_charge_rule
      @discount_rule = discount_rule
      @discount = discount
    end

    def add(product_code)
      product = catalogue.products.find { |p| p.code == product_code }
      raise Bakool::InvalidProductCodeError, "Invalid product code: #{product_code}" if product.nil?

      @items << product
    end

    def total
      total_in_cents_before_adjustments = 0
      items.each do |item|
        total_in_cents_before_adjustments += item.price_in_cents
      end
      discounts = discount.calculate(self)
      total_in_cents_after_discounts = total_in_cents_before_adjustments - discounts
      delivery_charge = delivery_charge_rule.calculate(total_in_cents_after_discounts)
      (total_in_cents_after_discounts + delivery_charge) / 100.0
    end

    def show_total
      items
    end
  end
end
