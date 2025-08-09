# frozen_string_literal: true

# A rule that calculates delivery charges based on order total
module Bakool
  # Represents a rule that calculates delivery charges based on order total.
  # Can be customized with a custom calculation function or use the default logic.
  #
  # @example
  #   rule = Bakool::DeliveryChargeRule.new
  #   charge = rule.calculate(5000) # 0 cents for orders (free delivery by default)
  #
  # @example Custom rule
  #   custom_rule = Bakool::DeliveryChargeRule.new(->(total) { total > 5000 ? 0 : 1000 })
  #
  # @attr_reader func [Proc] The function that calculates delivery charges
  class DeliveryChargeRule
    attr_accessor :func

    # @param func [Proc] A function that takes an order total in cents and returns the delivery charge in cents
    def initialize(func = nil)
      @func = func || ->(order_total) { 0 }
    end

    # Returns the delivery charge in cents
    # We only take order_total because delivery charges are not dependent on the basket's composition (for now)
    def calculate(order_total)
      @func.call(order_total)
    end

    def self.default_delivery_charge_rule
      Bakool::DeliveryChargeRule.new
    end
  end
end
