class Discount
  def calculate(basket)
    raise NotImplementedError, "Subclasses must implement this method"
  end
end