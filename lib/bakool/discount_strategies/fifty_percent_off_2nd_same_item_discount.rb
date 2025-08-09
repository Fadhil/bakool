# frozen_string_literal: true

# Discount strategy that applies 50% off the second item of the same type
module Bakool
  class FiftyPercentOff2ndSameItemDiscount < Discount
    def initialize(item_code)
      super()
      @item_code = item_code
    end

    def calculate(basket)
      matching_items = basket.items.filter { |item| item.code == @item_code }
      return 0 unless matching_items.count >= 2

      (matching_items.first.price_in_cents / 2.0).ceil
    end
  end
end
