class Basket
  attr_accessor :catalogue, :items, :delivery_charge_rule, :discount_rule

  require_relative "catalogue"
  require_relative "delivery_charge_rule"
  require_relative "discount_rule"
  require_relative "../errors/invalid_product_code_error"

  def initialize(catalogue: Catalogue::default_catalogue, delivery_charge_rule: DeliveryChargeRule::default_delivery_charge_rule, discount_rule: DiscountRule::default_discount_rule)
    @catalogue = catalogue
    @items = []
    @delivery_charge_rule = delivery_charge_rule
    @discount_rule = discount_rule
  end

  def add(product_code)
    product = catalogue.products.find { |product| product.code == product_code }
    if product.nil?
      raise InvalidProductCodeError, "Invalid product code: #{product_code}"
    end
    @items << product
  end

  def total
    total_in_cents_before_adjustments = 0
    items.each do |item|
      total_in_cents_before_adjustments += item.price_in_cents
    end
    discounts = discount_rule.calculate(self)
    total_in_cents_after_discounts = total_in_cents_before_adjustments - discounts
    delivery_charge = delivery_charge_rule.calculate(total_in_cents_after_discounts)
    (total_in_cents_after_discounts + delivery_charge) / 100.0
  end

  def show_total
    items
  end
end
