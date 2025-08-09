# frozen_string_literal: true

# A product that can be added to a shopping basket
module Bakool
  class Product
    attr_accessor :name, :code, :price

    def initialize(name, code, price = 0)
      raise ArgumentError, "Name and code are required" if name.nil? || name.empty? || code.nil? || code.empty?

      raise ArgumentError, "Price must be a positive number" if price.nil? || price.negative?

      @name = name
      @code = code
      @price = price
    end

    def price_in_cents
      (@price * 100).to_i
    end
  end
end
