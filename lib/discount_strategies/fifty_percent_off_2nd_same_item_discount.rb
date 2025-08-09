class FiftyPercentOff2ndSameItemDiscount < Discount
  def initialize(item_code)
    @item_code = item_code
  end

  def calculate(basket)
    basket.items.filter { |item| item.code == @item_code }.count >= 2 ? (basket.items.find { |item| item.code == @item_code }.price_in_cents / 2.0).ceil : 0
  end
end