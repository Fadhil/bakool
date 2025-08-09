# frozen_string_literal: true

# Abstract base class for discount strategies
class Discount
  def calculate(basket)
    raise NotImplementedError, "Subclasses must implement this method"
  end
end
