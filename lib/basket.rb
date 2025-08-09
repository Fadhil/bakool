class Basket
  attr_accessor :catalogue, :items

  require_relative "../errors/invalid_product_code_error"

  def initialize(catalogue = Catalogue::default_catalogue)
    @catalogue = catalogue
    @items = []
  end

  def add(product_code)
    product = catalogue.products.find { |product| product.code == product_code }
    if product.nil?
      raise InvalidProductCodeError, "Invalid product code: #{product_code}"
    end
    @items << product
  end
end
