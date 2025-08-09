require_relative "discount"

class DefaultDiscount < Discount
  def calculate(basket)
    0
  end

  def self.default_discount
    DefaultDiscount.new
  end
end