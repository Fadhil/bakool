class Basket
  attr_accessor :catalogue, :items, :delivery_charge_rule

  require_relative "../errors/invalid_product_code_error"

  def initialize(catalogue: Catalogue::default_catalogue, delivery_charge_rule: DeliveryChargeRule::default_delivery_charge_rule)
    @catalogue = catalogue
    @items = []
    @delivery_charge_rule = delivery_charge_rule
  end

  def add(product_code)
    product = catalogue.products.find { |product| product.code == product_code }
    if product.nil?
      raise InvalidProductCodeError, "Invalid product code: #{product_code}"
    end
    @items << product
  end

  def total
    total_in_cents = 0
    items.each do |item|
      total_in_cents += item.price_in_cents
    end
    delivery_charges = delivery_charge_rule.calculate(total_in_cents)
    total_in_cents = total_in_cents + delivery_charges
    total_in_cents / 100.0
  end

  def show_total
    items
  end
end
