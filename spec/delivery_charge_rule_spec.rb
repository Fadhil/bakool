require "delivery_charge_rule"

describe DeliveryChargeRule do
   context "without a charge function and order total is 0" do
    it "should return 0" do
      delivery_charge_rule = DeliveryChargeRule.new

      expect(delivery_charge_rule.calculate(0)).to eq(0)
    end
   end

   context "without a charge function and order total is greater than 0" do
    it "should return 4.99 in cents" do
      delivery_charge_rule = DeliveryChargeRule.new

      expect(delivery_charge_rule.calculate(100)).to eq(499)
    end
   end
   
   context "with a charge function" do
    it "should return the result of the charge function" do
      rules = Proc.new do |order_total|
        if order_total >= 2000 then 0
        elsif order_total >= 100 then 299
        else 499
        end
      end
      
      delivery_charge_rule = DeliveryChargeRule.new(rules)

      expect(delivery_charge_rule.calculate(100)).to eq(299)
      expect(delivery_charge_rule.calculate(99)).to eq(499)
      expect(delivery_charge_rule.calculate(2000)).to eq(0)
    end
   end
end