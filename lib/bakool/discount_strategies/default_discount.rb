# frozen_string_literal: true

require_relative "discount"

# Default discount strategy that applies no discount
module Bakool
  # Default discount strategy that applies no discount to the basket.
  # This is the fallback discount strategy when no other discounts are applicable.
  #
  # @example
  #   discount = Bakool::DefaultDiscount.new
  #   amount = discount.calculate(basket) # Always returns 0
  #
  # @see Bakool::Discount
  class DefaultDiscount < Discount
    def calculate(_basket)
      0
    end

    def self.default_discount
      Bakool::DefaultDiscount.new
    end
  end
end
