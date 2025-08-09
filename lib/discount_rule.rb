class DiscountRule
  attr_accessor :func

  def initialize(func = nil)
    @func = func || lambda { |basket| 0 }
  end

  def calculate(basket)
    @func.call(basket)
  end

  def self.default_discount_rule
    DiscountRule.new
  end
end