# frozen_string_literal: true

require "./lib/shipping_calculator/package_detail"

RSpec.describe ShippingCalculator::PackageDetail do
  subject(:detail) do
    ShippingCalculator::PackageDetail.new(data_line)
  end
  let(:data_line) { "2015-02-24 L LP" }

  describe "#initialize" do
    context "with correct string" do
      it "creates an instance with correct values" do
        expect(detail.size).to eq "L"
        expect(detail.carrier).to eq "LP"
        expect(detail.date).to eq "2015-02-24"
      end
    end

    context "with invalid carrier" do
      let(:data_line) { "2015-02-24 L DHL" }

      it "invalides record" do
        expect(detail.carrier).to be_falsy
        expect(detail).not_to be_valid
      end
    end

    context "when the data line has two fields" do
      let(:data_line) { "2015-02-24 L" }

      it "invalides record" do
        expect(detail).not_to be_valid
      end
    end

    # For now, the extra values after the third, are just ignored.
    context "when the data line has four fields" do
      let(:data_line) { "2015-02-24 L LP LP" }

      it "create a valid instance if firsts 3 fields are valid" do
        expect(detail).to be_valid
        expect(detail.size).to eq "L"
        expect(detail.carrier).to eq "LP"
        expect(detail.date).to eq "2015-02-24"
      end
    end

    context "when data_line is empty" do
      let(:data_line) { "" }

      it "returns empty fields" do
        expect(detail.original).to be_empty
        expect(detail).not_to be_valid
      end
    end
  end

  # TODO: validity will benefit from metaprogramming or shared examples
  describe "#valid_date?" do
    context "with valid date" do
      let(:data_line) { "2015-02-24 L LP" }

      it { expect(detail).to be_valid_date }
      it { expect(detail).to be_valid }
    end

    context "with invalid date" do
      let(:data_line) { "24-05-2014 L LP" }

      it { expect(detail).not_to be_valid_date }
      it { expect(detail).not_to be_valid }
    end
  end

  describe "#valid_size?" do
    context "with valid size" do
      let(:data_line) { "2015-02-24 L LP" }

      it { expect(detail).to be_valid_date }
      it { expect(detail).to be_valid }
    end

    context "with invalid size" do
      let(:data_line) { "2015-02-24 XL LP" }

      it { expect(detail).not_to be_valid_size }
      it { expect(detail).not_to be_valid }
    end
  end

  describe "#valid_carrier?" do
    context "with valid carrier" do
      let(:data_line) { "2015-02-24 L LP" }

      it { expect(detail).to be_valid_carrier }
      it { expect(detail).to be_valid }
    end

    context "with invalid carrier" do
      let(:data_line) { "2015-02-24 XL DHL" }

      it { expect(detail).not_to be_valid_carrier }
      it { expect(detail).not_to be_valid }
    end
  end
end
