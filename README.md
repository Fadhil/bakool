# Bakool: Shopping Basket Library

A flexible Ruby library for managing shopping baskets with support for products, delivery charges, and discount strategies.

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

### Discount Strategies

The library uses the Strategy Pattern for discounts, making it easy to implement and extend different discount types.

#### Using Built-in Discount Strategies

```ruby
# Use the default discount (no discount)
basket = Basket.new(discount: DefaultDiscount.new)

# Use 50% off second same item discount for Red Widgets
discount = FiftyPercentOff2ndSameItemDiscount.new("R01")
basket = Basket.new(discount: discount)
```

#### Creating Custom Discount Strategies

```ruby
# Create a custom discount strategy
class BuyOneGetOneFreeDiscount < Discount
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
basket = Basket.new(discount: discount)
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

# Use 50% off second Red Widget discount
discount = FiftyPercentOff2ndSameItemDiscount.new("R01")

basket = Basket.new(
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

#### `Basket.new(catalogue:, delivery_charge_rule:, discount_rule:, discount:)`

Creates a new basket instance.

- `catalogue` (optional): Product catalogue (defaults to `Catalogue.default_catalogue`)
- `delivery_charge_rule` (optional): Delivery charge calculation rule (defaults to `DeliveryChargeRule.default_delivery_charge_rule`)
- `discount_rule` (optional): Legacy discount rule (defaults to `DiscountRule.default_discount_rule`)
- `discount` (optional): Discount strategy (defaults to `DefaultDiscount.default_discount`)

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

### Discount Strategies

The discount system uses the Strategy Pattern for flexible and extensible discount calculations.

#### `Discount`

Base class for all discount strategies.

#### `discount.calculate(basket)`

Calculates discount for a basket.

- `basket` (Basket): Basket object
- Returns: `Integer` - Discount amount in cents

#### `DefaultDiscount`

Default discount strategy that applies no discount.

```ruby
discount = DefaultDiscount.new
# or
discount = DefaultDiscount.default_discount
```

#### `FiftyPercentOff2ndSameItemDiscount`

Applies 50% discount to the second item of the same type.

```ruby
# 50% off second Red Widget
discount = FiftyPercentOff2ndSameItemDiscount.new("R01")
```

#### Creating Custom Discount Strategies

To create a custom discount strategy, inherit from the `Discount` base class:

```ruby
class CustomDiscount < Discount
  def initialize(parameters)
    # Initialize your discount strategy
  end

  def calculate(basket)
    # Implement your discount logic
    # Return discount amount in cents
  end
end
```

### Legacy DiscountRule

**Note**: This is the legacy discount system. New code should use the Strategy Pattern approach.

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


