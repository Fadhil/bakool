# Bakool: Shopping Basket Library
[![Gem Version](https://badge.fury.io/rb/bakool.svg)](https://badge.fury.io/rb/bakool)

A flexible Ruby gem for managing shopping baskets with support for products, delivery charges, and discount strategies.

## Features

- 🛒 **Shopping Basket Management**: Add products to a basket and calculate totals
- 📦 **Product Catalogue**: Manage product inventory with codes, names, and prices
- 🚚 **Flexible Delivery Charges**: Configurable delivery charge rules based on order total
- 🎯 **Discount Strategies**: Extensible discount strategy pattern for promotional offers
- 🧪 **Test Coverage**: Comprehensive test suite with RSpec
- 🔧 **Extensible Design**: Easy to extend with custom rules and behaviors

## Assumptions made for development:

- We're dealing with an unspecified currency that uses 2 decimal places for cents
- We currently will only support having one discount strategy and one delivery charge rule per basket
- Delivery calculations are only done based on the total price after discount and is not dependent on what items are in the basket
- Discount calculations depend on the items/item combinations in the basket

## Installation

### From RubyGems (Recommended)

Add this line to your application's Gemfile:

```ruby
gem 'bakool'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install bakool
```

### From Source

1. Clone the repository:
```bash
git clone https://github.com/fadhil-luqman/bakool.git
cd bakool
```

2. Install dependencies:
```bash
bundle install
```

3. Build and install the gem locally:
```bash
bundle exec rake install
```

## Usage

### Basic Usage

```ruby
require 'bakool'

# Create a basket with default catalogue and rules
# Note: Delivery is free by default (no delivery charges applied)
basket = Bakool::Basket.new

# Add products by their codes
basket.add("R01")  # Red Widget
basket.add("G01")  # Green Widget
basket.add("B01")  # Blue Widget

# Calculate total (includes delivery charges and discounts)
total = basket.total
puts "Total: $#{total}"
```

### Default Products

The gem comes with a default catalogue containing:

| Code | Name | Price |
|------|------|-------|
| R01  | Red Widget | $32.95 |
| G01  | Green Widget | $24.95 |
| B01  | Blue Widget | $7.95 |

### Custom Catalogues

You can create your own custom catalogue with your own products. This is useful when you want to use different products or pricing than the default catalogue.

#### Creating a Custom Catalogue

```ruby
# Create a new empty catalogue
catalogue = Bakool::Catalogue.new

# Add products to your catalogue
catalogue.add_product(Bakool::Product.new("Laptop", "LAP01", 999.99))
catalogue.add_product(Bakool::Product.new("Mouse", "MOU01", 25.50))
catalogue.add_product(Bakool::Product.new("Keyboard", "KEY01", 75.00))
catalogue.add_product(Bakool::Product.new("Monitor", "MON01", 299.99))

# Create a basket with your custom catalogue
basket = Bakool::Basket.new(catalogue: catalogue)

# Add products using your custom codes
basket.add("LAP01")  # Laptop
basket.add("MOU01")  # Mouse
basket.add("KEY01")  # Keyboard

# Calculate total
total = basket.total
puts "Total: $#{total}"
```

#### Complete Custom Catalogue Example

```ruby
# Create a custom catalogue for an electronics store
electronics_catalogue = Bakool::Catalogue.new

# Add electronics products
electronics_catalogue.add_product(Bakool::Product.new("iPhone 15", "IPH15", 799.99))
electronics_catalogue.add_product(Bakool::Product.new("AirPods Pro", "AIRPODS", 249.99))
electronics_catalogue.add_product(Bakool::Product.new("MacBook Air", "MBA", 1199.99))
electronics_catalogue.add_product(Bakool::Product.new("iPad Air", "IPAD", 599.99))

# Create custom delivery charge rule for electronics
electronics_delivery = Bakool::DeliveryChargeRule.new(lambda do |order_total|
  if order_total < 10000 then 995      # $9.95 for orders under $100
  elsif order_total < 50000 then 495   # $4.95 for orders under $500
  else 0                              # Free delivery for orders $500+
  end
end)

# Create custom discount for AirPods (buy one get one 25% off)
class AirPodsDiscount < Bakool::Discount
  def calculate(basket)
    airpods = basket.items.filter { |item| item.code == "AIRPODS" }
    if airpods.count >= 2
      # Apply 25% discount to every second AirPod
      (airpods.count / 2) * (airpods.first.price_in_cents * 0.25)
    else
      0
    end
  end
end

# Create basket with custom catalogue, delivery, and discount
basket = Bakool::Basket.new(
  catalogue: electronics_catalogue,
  delivery_charge_rule: electronics_delivery,
  discount: AirPodsDiscount.new
)

# Add items
basket.add("IPH15")   # iPhone 15
basket.add("AIRPODS") # AirPods Pro
basket.add("AIRPODS") # Second AirPods Pro (25% off)
basket.add("MBA")     # MacBook Air

# Calculate total
total = basket.total
puts "Total: $#{total}"
```

#### Catalogue API Reference

##### `Bakool::Catalogue.new`

Creates a new empty catalogue.

```ruby
catalogue = Bakool::Catalogue.new
```

##### `catalogue.add_product(product)`

Adds a product to the catalogue.

- `product` (Bakool::Product): Product object to add

```ruby
catalogue.add_product(Bakool::Product.new("Product Name", "CODE", 29.99))
```

##### `Bakool::Catalogue.default_catalogue`

Returns a catalogue with the default products (Red Widget, Green Widget, Blue Widget).

```ruby
default_catalogue = Bakool::Catalogue.default_catalogue
```

### Custom Delivery Charges

By default, delivery is free (no delivery charges are applied). You can create custom delivery charge rules to implement your own pricing logic.

```ruby
# Create custom delivery charge rule
delivery_rule = Bakool::DeliveryChargeRule.new(lambda do |order_total|
  if order_total < 5000 then 495      # $4.95 for orders under $50
  elsif order_total < 9000 then 295   # $2.95 for orders under $90
  else 0                              # Free delivery for orders $90+
  end
end)

basket = Bakool::Basket.new(delivery_charge_rule: delivery_rule)
```

### Discount Strategies

The gem uses the Strategy Pattern for discounts, making it easy to implement and extend different discount types.

#### Using Built-in Discount Strategies

```ruby
# Use the default discount (no discount)
basket = Bakool::Basket.new(discount: Bakool::DefaultDiscount.new)

# Use 50% off second same item discount for Red Widgets
discount = Bakool::FiftyPercentOff2ndSameItemDiscount.new("R01")
basket = Bakool::Basket.new(discount: discount)
```

#### Creating Custom Discount Strategies

```ruby
# Create a custom discount strategy
class BuyOneGetOneFreeDiscount < Bakool::Discount
  def initialize(item_code)
    @item_code = item_code
  end

  def calculate(basket)
    items = basket.items.filter { |item| item.code == @item_code }
    if items.count >= 2
      # Apply 100% discount to every second item
      (items.count / 2) * items.first.price_in_cents
    else
      0
    end
  end
end

# Use the custom discount
discount = BuyOneGetOneFreeDiscount.new("R01")
basket = Bakool::Basket.new(discount: discount)
```

### Complete Example

```ruby
# Create basket with custom rules
delivery_rule = Bakool::DeliveryChargeRule.new(lambda do |order_total|
  if order_total < 5000 then 495
  elsif order_total < 9000 then 295
  else 0
  end
end)

# Use 50% off second Red Widget discount
discount = Bakool::FiftyPercentOff2ndSameItemDiscount.new("R01")

basket = Bakool::Basket.new(
  delivery_charge_rule: delivery_rule,
  discount: discount
)

# Add items
basket.add("R01")  # Red Widget
basket.add("R01")  # Second Red Widget (50% off)
basket.add("G01")  # Green Widget

# Calculate total
total = basket.total
puts "Total: $#{total}"  # Output: Total: $54.37
```

## API Reference

### Basket

The main class for managing shopping baskets.

#### `Bakool::Basket.new(catalogue:, delivery_charge_rule:, discount_rule:, discount:)`

Creates a new basket instance.

- `catalogue` (optional): Product catalogue (defaults to `Bakool::Catalogue.default_catalogue`)
- `delivery_charge_rule` (optional): Delivery charge calculation rule (defaults to `Bakool::DeliveryChargeRule.default_delivery_charge_rule`)
- `discount_rule` (optional): Legacy discount rule (defaults to `Bakool::DiscountRule.default_discount_rule`)
- `discount` (optional): Discount strategy (defaults to `Bakool::DefaultDiscount.default_discount`)

#### `basket.add(product_code)`

Adds a product to the basket by its code.

- `product_code` (String): The product code to add
- Raises `Bakool::InvalidProductCodeError` if the product code doesn't exist

#### `basket.total`

Calculates the total price including delivery charges and discounts.

- Returns: `Float` - Total price in dollars

#### `basket.show_total`

Returns the items in the basket.

- Returns: `Array` - Array of Product objects

### Product

Represents a product in the catalogue.

#### `Bakool::Product.new(name, code, price)`

Creates a new product.

- `name` (String): Product name (required)
- `code` (String): Product code (required)
- `price` (Float): Product price in dollars (default: 0)

### Catalogue

Manages the product inventory.

#### `Bakool::Catalogue.new`

Creates a new empty catalogue.

```ruby
catalogue = Bakool::Catalogue.new
```

#### `catalogue.add_product(product)`

Adds a product to the catalogue.

- `product` (Bakool::Product): Product object to add

```ruby
catalogue.add_product(Bakool::Product.new("Product Name", "CODE", 29.99))
```

#### `Bakool::Catalogue.default_catalogue`

Returns a catalogue with default products (Red Widget, Green Widget, Blue Widget).

```ruby
default_catalogue = Bakool::Catalogue.default_catalogue
```

### DeliveryChargeRule

Handles delivery charge calculations.

#### `Bakool::DeliveryChargeRule.new(func)`

Creates a new delivery charge rule.

- `func` (Proc, optional): Function that takes order total in cents and returns delivery charge in cents

#### `delivery_charge_rule.calculate(order_total)`

Calculates delivery charge for an order total.

- `order_total` (Integer): Order total in cents
- Returns: `Integer` - Delivery charge in cents

### Discount Strategies

The discount system uses the Strategy Pattern for flexible and extensible discount calculations.

#### `Bakool::Discount`

Base class for all discount strategies.

#### `discount.calculate(basket)`

Calculates discount for a basket.

- `basket` (Bakool::Basket): Basket object
- Returns: `Integer` - Discount amount in cents

#### `Bakool::DefaultDiscount`

Default discount strategy that applies no discount.

```ruby
discount = Bakool::DefaultDiscount.new
# or
discount = Bakool::DefaultDiscount.default_discount
```

#### `Bakool::FiftyPercentOff2ndSameItemDiscount`

Applies 50% discount to the second item of the same type.

```ruby
# 50% off second Red Widget
discount = Bakool::FiftyPercentOff2ndSameItemDiscount.new("R01")
```

#### Creating Custom Discount Strategies

To create a custom discount strategy, inherit from the `Bakool::Discount` base class:

```ruby
class CustomDiscount < Bakool::Discount
  def initialize(parameters)
    # Initialize your discount strategy
  end

  def calculate(basket)
    # Implement your discount logic
    # Return discount amount in cents
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

Run the test suite:

```bash
bundle exec rspec
```

## Error Handling

The gem includes custom error classes:

- `Bakool::InvalidProductCodeError`: Raised when trying to add a product with an invalid code

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fadhil-luqman/bakool. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/fadhil-luqman/bakool/blob/main/CODE_OF_CONDUCT.md).

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bakool project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fadhil-luqman/bakool/blob/main/CODE_OF_CONDUCT.md).


