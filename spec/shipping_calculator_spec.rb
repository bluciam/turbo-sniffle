# frozen_string_literal: true

require "./lib/shipping_calculator/shipping_calculator"
require "./lib/shipping_calculator/text_file_parser"

RSpec.describe ShippingCalculator::ShippingCalculator do
  it "raises error when file argument is missing" do
    expect do
      ShippingCalculator::ShippingCalculator.run
    end.to raise_error ArgumentError
  end

  it "raises error when file does not exist" do
    expect do
      ShippingCalculator::ShippingCalculator.run("hello")
    end.to raise_error RuntimeError
  end

  it "calls TextFileparser when the file exists" do
    allow(ShippingCalculator::TextFileParser).to receive(:run)
    allow(File).to receive(:exist?).and_return(true)

    ShippingCalculator::ShippingCalculator.run("hello.txt")
    expect(ShippingCalculator::TextFileParser).to have_received(:run)
  end
end
