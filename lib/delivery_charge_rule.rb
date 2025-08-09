class DeliveryChargeRule
    attr_accessor :func

    def initialize(func = nil)
        @func = func || lambda { |order_total|  if order_total > 0 then 499 else 0 end }
    end

    def calculate(order_total)
        @func.call(order_total)
    end
end