# frozen_string_literal: true

# Abstract base class for discount strategies
module Bakool
  class Discount
    def calculate(basket)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end
