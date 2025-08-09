class DeliveryChargeRule
  attr_accessor :func

  # @param func [Proc] A function that takes an order total in cents and returns the delivery charge in cents
  def initialize(func = nil)
    @func = func || lambda { |order_total| if order_total > 0 then 495 else 0 end }
  end

  # Returns the delivery charge in cents
  def calculate(order_total)
    @func.call(order_total)
  end

  def self.default_delivery_charge_rule
    DeliveryChargeRule.new
  end
end
