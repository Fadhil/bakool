class Product
  attr_accessor :name, :code, :price

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
  end
end
