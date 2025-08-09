class Product
  attr_accessor :name, :code, :price, :price_in_cents

  def initialize(name, code, price = 0)
    if name.nil? || name.empty? || code.nil? || code.empty?
      raise ArgumentError, "Name and code are required"
    end

    if price.nil? || price < 0
      raise ArgumentError, "Price must be a positive number"
    end

    @name = name
    @code = code
    @price = price
    @price_in_cents = price_in_cents
  end

  def price_in_cents
    @price * 100
  end
end
