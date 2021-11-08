# frozen_string_literal: true

require "./lib/shipping_calculator/monthly_list"

RSpec.describe ShippingCalculator::MonthlyList do
  let(:monthly_list) do
    ShippingCalculator::MonthlyList.new(data_lines)
  end

  describe "#initialize" do
    context "with correct string" do
      let(:data_lines) { ["2015-02-24 L LP", "2015-02-20 S MR"] }

      it "creates an instance with correct values" do
        expect(monthly_list.transactions.count).to eq 2
      end
    end

    context "with incorrect data lines" do
      let(:data_lines) { ["", "2015-02-20 S MR LP"] }

      it "creates invalid packing details objects" do
        expect(monthly_list.transactions.map(&:valid?).uniq.first).to be_falsy
      end
    end

    context "when data_lines is nil" do
      let(:data_lines) { nil }

      it "returns empty transactions" do
        expect(monthly_list.transactions).to be_empty
      end
    end

    context "when data_lines is emtpy array" do
      let(:data_lines) { [] }

      it "returns empty transactions" do
        expect(monthly_list.transactions).to be_empty
      end
    end
  end

  # rubocop:disable Layout/MultilineMethodCallIndentation
  # Makes the chained expectatations `to_change` easier to read.
  describe "#set_discount" do
    describe "when transaction is a large package" do
      let(:monthly_list) do
        ShippingCalculator::MonthlyList.new(["2015-02-14 L LP"])
      end
      let(:transaction) { monthly_list.transactions.first }

      context "when a full discount can be applied" do
        before do
          monthly_list.transactions.first.full_price = 690
          monthly_list.cumm_discount = 50
        end

        it "updates all" do
          expect { monthly_list.set_discount(690, transaction) }
            .to change(transaction, :end_price).to(0)
            .and change(transaction, :discount).to(690)
            .and change(monthly_list, :cumm_discount).by(690)
        end
      end

      context "when a partial discount can be applied" do
        before do
          monthly_list.transactions.first.full_price = 690
          monthly_list.cumm_discount = 500
        end

        it "partially updates all" do
          expect { monthly_list.set_discount(690, transaction) }
            .to change(transaction, :end_price).to(190)
            .and change(transaction, :discount).to(500)
            .and change(monthly_list, :cumm_discount).by(500)
          expect(monthly_list.cumm_discount).to eq 1000
        end
      end

      context "when no discount ca be apllied" do
        before do
          monthly_list.transactions.first.full_price = 690
          monthly_list.cumm_discount = 1000
        end

        it "updates only fields in the transaction" do
          expect { monthly_list.set_discount(690, transaction) }
            .to change(transaction, :end_price).to(690)
            .and change(transaction, :discount).to(0)
          expect(monthly_list.cumm_discount).to eq 1000
        end
      end
    end

    describe "when transaction is a small package from LP" do
      let(:monthly_list) do
        ShippingCalculator::MonthlyList.new(["2015-02-14 S MR"])
      end
      let(:transaction) { monthly_list.transactions.first }

      context "when a partial discount can be applied" do
        before do
          monthly_list.transactions.first.full_price = 200
          monthly_list.cumm_discount = 980
        end

        it "updates only fields in the transaction" do
          expect { monthly_list.set_discount(50, transaction) }
            .to change(transaction, :end_price).to(180)
            .and change(transaction, :discount).to(20)
          expect(monthly_list.cumm_discount).to eq 1000
        end
      end
    end
  end

  describe "#discounted_list" do
    let(:data_lines) { ["2015-02-24 L LP"] }
    before do
      monthly_list.transactions.first.full_price = 100
      monthly_list.transactions.first.discount = 0
    end

    it "ships the third one for free" do
      expect(monthly_list.discounted_list).to be
    end
  end

  describe "#calculate_costs" do
    context "when there are 4 large packages", :aggregate_failures do
      let(:data_lines) do
        ["2015-02-14 L LP",
         "2015-02-20 L LP",
         "2015-02-21 L LP",
         "2015-02-24 L LP"]
      end

      before { monthly_list }

      it "ships the third one for free" do
        expect { monthly_list.calculate_costs }
          .to change(monthly_list, :cumm_discount).from(0).to(690)
          .and change(monthly_list, :total_large_pkgs).from(0).to(4)

        expect(
          monthly_list.transactions.map(&:discount)
        ).to contain_exactly(0, 0, 690, 0)
        expect(
          monthly_list.transactions.map(&:end_price)
        ).to contain_exactly(0, 690, 690, 690)
      end
    end
    # rubocop:enable Layout/MultilineMethodCallIndentation
  end
end
