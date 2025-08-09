# frozen_string_literal: true

RSpec.describe Bakool do
  it "has a version number" do
    expect(Bakool::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(Bakool::Basket.new).to  be_a(Bakool::Basket)
  end
end
