# frozen_string_literal: true

# Abstract base class for discount strategies
module Bakool
  # Abstract base class for discount strategies.
  # Subclasses must implement the #calculate method to provide specific discount logic.
  #
  # @example
  #   class MyDiscount < Bakool::Discount
  #     def calculate(basket)
  #       # Custom discount logic here
  #       1000 # Return discount amount in cents
  #     end
  #   end
  #
  # @abstract Subclasses must implement {#calculate}
  class Discount
    def calculate(basket)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end
