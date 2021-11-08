# frozen_string_literal: true

require "./lib/shipping_calculator/text_file_parser"
require "./lib/shipping_calculator/shipping_calculator"

RSpec.describe ShippingCalculator::TextFileParser do
  it "raises error when file argument is missing" do
    expect do
      ShippingCalculator::TextFileParser.run("hello.txt")
    end.to raise_error RuntimeError
  end

  it "calls TextFileparser when the file exists" do
    allow(ShippingCalculator::ProcessByGroup).to receive(:run)
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:readlines).and_return([])

    ShippingCalculator::TextFileParser.run("hello.txt")
    expect(ShippingCalculator::ProcessByGroup).to have_received(:run)
  end
end
