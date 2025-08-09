# frozen_string_literal: true

require_relative "discount"

# Default discount strategy that applies no discount
module Bakool
  class DefaultDiscount < Discount
    def calculate(_basket)
      0
    end

    def self.default_discount
      Bakool::DefaultDiscount.new
    end
  end
end
