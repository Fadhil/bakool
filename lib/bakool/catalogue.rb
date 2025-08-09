# frozen_string_literal: true

# A catalogue that holds a collection of products
module Bakool
  class Catalogue
    attr_accessor :products

    def initialize
      @products = []
    end

    def add_product(product)
      @products << product
    end

    def self.default_catalogue
      catalogue = Catalogue.new
      catalogue.add_product(Bakool::Product.new("Red Widget", "R01", 32.95))
      catalogue.add_product(Bakool::Product.new("Green Widget", "G01", 24.95))
      catalogue.add_product(Bakool::Product.new("Blue Widget", "B01", 7.95))
      catalogue
    end
  end
end
