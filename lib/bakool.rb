# frozen_string_literal: true

require_relative "bakool/version"

module Bakool
  class Error < StandardError; end
  # Your code goes here...
end

require_relative "bakool/basket"
require_relative "bakool/catalogue"
require_relative "bakool/delivery_charge_rule"
require_relative "bakool/product"
require_relative "bakool/discount_strategies/discount"
require_relative "bakool/discount_strategies/default_discount"
require_relative "bakool/discount_strategies/fifty_percent_off_2nd_same_item_discount"
require_relative "bakool/errors/invalid_product_code_error"
