class DiscountRule
  attr_accessor :func

  def initialize(func = nil)
    @func = func || lambda { |basket| 0 }
  end

  # We take a basket because want to be able to calculate the discount based on the entire basket's composition
  def calculate(basket)
    @func.call(basket)
  end

  def self.default_discount_rule
    DiscountRule.new
  end
end
