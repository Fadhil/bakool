# frozen_string_literal: true

# A catalogue that holds a collection of products
module Bakool
  # Represents a catalogue that holds a collection of products.
  # Provides methods to add products and retrieve the default catalogue.
  #
  # @example
  #   catalogue = Bakool::Catalogue.new
  #   catalogue.add_product(Bakool::Product.new("Widget", "W01", 10.00))
  #   default_catalogue = Bakool::Catalogue.default_catalogue
  #
  # @attr_reader products [Array<Bakool::Product>] The products in the catalogue
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
