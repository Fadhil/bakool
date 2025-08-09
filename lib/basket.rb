# frozen_string_literal: true

# A shopping basket that can hold products and calculate totals with discounts and delivery charges
class Basket
  attr_accessor :catalogue, :items, :delivery_charge_rule, :discount_rule, :discount

  require_relative "catalogue"
  require_relative "delivery_charge_rule"
  require_relative "discount_strategies/default_discount"
  require_relative "../errors/invalid_product_code_error"

  def initialize(catalogue: Catalogue.default_catalogue,
                 delivery_charge_rule: DeliveryChargeRule.default_delivery_charge_rule,
                 discount: DefaultDiscount.default_discount)
    @catalogue = catalogue
    @items = []
    @delivery_charge_rule = delivery_charge_rule
    @discount_rule = discount_rule
    @discount = discount
  end

  def add(product_code)
    product = catalogue.products.find { |p| p.code == product_code }
    raise InvalidProductCodeError, "Invalid product code: #{product_code}" if product.nil?

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
