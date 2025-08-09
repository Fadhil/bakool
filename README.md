# Bakool: Shopping Basket Library

A flexible Ruby library for managing shopping baskets with support for products, delivery charges, and discount rules.

## Features

- 🛒 **Shopping Basket Management**: Add products to a basket and calculate totals
- 📦 **Product Catalogue**: Manage product inventory with codes, names, and prices
- 🚚 **Flexible Delivery Charges**: Configurable delivery charge rules based on order total
- 🎯 **Discount Rules**: Customizable discount calculations for promotional offers
- 🧪 **Test Coverage**: Comprehensive test suite with RSpec
- 🔧 **Extensible Design**: Easy to extend with custom rules and behaviors


## Assumptions made for development:

- We're dealing with an unspecified currency that uses 2 decimal places for cents
- We currently will only support having one discount rule and one delivery charge rule per basket
- Delivery calculations are only done based on the total price after discount and is not dependent on what items are in the basket
- Discount calculations depends on the items/item combinations in the basket


## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd bakool
```

2. Install dependencies:
```bash
bundle install
```

## Usage

### Basic Usage

```ruby
require_relative 'lib/basket'

# Create a basket with default catalogue and rules
basket = Basket.new

# Add products by their codes
basket.add("R01")  # Red Widget
basket.add("G01")  # Green Widget
basket.add("B01")  # Blue Widget

# Calculate total (includes delivery charges and discounts)
total = basket.total
puts "Total: $#{total}"
```

### Default Products

The library comes with a default catalogue containing:

| Code | Name | Price |
|------|------|-------|
| R01  | Red Widget | $32.95 |
| G01  | Green Widget | $24.95 |
| B01  | Blue Widget | $7.95 |

### Custom Delivery Charges

```ruby
# Create custom delivery charge rule
delivery_rule = DeliveryChargeRule.new(lambda do |order_total|
  if order_total < 5000 then 495      # $4.95 for orders under $50
  elsif order_total < 9000 then 295   # $2.95 for orders under $90
  else 0                              # Free delivery for orders $90+
  end
end)

basket = Basket.new(delivery_charge_rule: delivery_rule)
```

### Custom Discount Rules

```ruby
# Create discount rule for "buy one get one half price" on Red Widgets
discount_rule = DiscountRule.new(lambda do |basket|
  red_widgets = basket.items.filter { |item| item.code == "R01" }
  if red_widgets.count >= 2
    # Apply 50% discount to second Red Widget
    (red_widgets.first.price_in_cents / 2.0).ceil
  else
    0
  end
end)

basket = Basket.new(discount_rule: discount_rule)
```

### Complete Example

```ruby
# Create basket with custom rules
delivery_rule = DeliveryChargeRule.new(lambda do |order_total|
  if order_total < 5000 then 495
  elsif order_total < 9000 then 295
  else 0
  end
end)

discount_rule = DiscountRule.new(lambda do |basket|
  red_widgets = basket.items.filter { |item| item.code == "R01" }
  if red_widgets.count >= 2
    (red_widgets.first.price_in_cents / 2.0).ceil
  else
    0
  end
end)

basket = Basket.new(
  delivery_charge_rule: delivery_rule,
  discount_rule: discount_rule
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

#### `Basket.new(catalogue:, delivery_charge_rule:, discount_rule:)`

Creates a new basket instance.

- `catalogue` (optional): Product catalogue (defaults to `Catalogue.default_catalogue`)
- `delivery_charge_rule` (optional): Delivery charge calculation rule (defaults to `DeliveryChargeRule.default_delivery_charge_rule`)
- `discount_rule` (optional): Discount calculation rule (defaults to `DiscountRule.default_discount_rule`)

#### `basket.add(product_code)`

Adds a product to the basket by its code.

- `product_code` (String): The product code to add
- Raises `InvalidProductCodeError` if the product code doesn't exist

#### `basket.total`

Calculates the total price including delivery charges and discounts.

- Returns: `Float` - Total price in dollars

#### `basket.show_total`

Returns the items in the basket.

- Returns: `Array` - Array of Product objects

### Product

Represents a product in the catalogue.

#### `Product.new(name, code, price)`

Creates a new product.

- `name` (String): Product name (required)
- `code` (String): Product code (required)
- `price` (Float): Product price in dollars (default: 0)

### Catalogue

Manages the product inventory.

#### `Catalogue.new`

Creates a new empty catalogue.

#### `catalogue.add_product(product)`

Adds a product to the catalogue.

- `product` (Product): Product object to add

#### `Catalogue.default_catalogue`

Returns a catalogue with default products (Red Widget, Green Widget, Blue Widget).

### DeliveryChargeRule

Handles delivery charge calculations.

#### `DeliveryChargeRule.new(func)`

Creates a new delivery charge rule.

- `func` (Proc, optional): Function that takes order total in cents and returns delivery charge in cents

#### `delivery_charge_rule.calculate(order_total)`

Calculates delivery charge for an order total.

- `order_total` (Integer): Order total in cents
- Returns: `Integer` - Delivery charge in cents

### DiscountRule

Handles discount calculations.

#### `DiscountRule.new(func)`

Creates a new discount rule.

- `func` (Proc, optional): Function that takes a basket and returns discount amount in cents

#### `discount_rule.calculate(basket)`

Calculates discount for a basket.

- `basket` (Basket): Basket object
- Returns: `Integer` - Discount amount in cents

## Testing

Run the test suite:

```bash
bundle exec rspec
```

## Error Handling

The library includes custom error classes:

- `InvalidProductCodeError`: Raised when trying to add a product with an invalid code

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.


