# frozen_string_literal: true

require "./lib/shipping_calculator/process_by_group"

RSpec.describe ShippingCalculator::ProcessByGroup do
  describe "#run" do
    it "runs smoothly with correct input" do
      expect(ShippingCalculator::ProcessByGroup.run([])).to be
    end
  end

  describe "#self.by_month" do
    let(:dates) { %w[2021-06-21 2021-07-20 2021-08-27] }
    let(:by_month_hash) { ShippingCalculator::ProcessByGroup.by_month(dates) }

    it "returns a aplit hash" do
      expect(by_month_hash.count).to eq 3
      expect(by_month_hash.keys).to contain_exactly(
        "202106", "202107", "202108"
      )
    end
  end

  describe "#self.process_by_month" do
    let(:grouped_by_month) do
      { "06" => ["2021-06-21"],
        nil => nil,
        "08" => ["2021-08-27"] }
    end
    let(:run_method) do
      ShippingCalculator::ProcessByGroup.process_by_month(grouped_by_month)
    end

    it { expect(run_method).to be }
  end
end
