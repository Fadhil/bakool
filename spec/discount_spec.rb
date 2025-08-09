require "discount_strategies/discount"
require "discount_strategies/fifty_percent_off_2nd_same_item_discount"

describe Discount do
    context "when there are less than 2 items with the same given code" do
        it "should return 0" do
            basket = Basket.new
            basket.add("R01")
            basket.add("B01")
            discount = FiftyPercentOff2ndSameItemDiscount.new("R01")
            discount_amount = discount.calculate(basket)
            expect(discount_amount).to eq(0)
        end
    end

    context "when there are at least 2 items with the same given code" do
        it "should return 0" do
            basket = Basket.new
            basket.add("R01")
            basket.add("R01")
            discount = FiftyPercentOff2ndSameItemDiscount.new("R01")
            discount_amount = discount.calculate(basket)
            expect(discount_amount).to eq(1648)
        end
    end
end