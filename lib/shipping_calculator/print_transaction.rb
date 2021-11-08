# frozen_string_literal: true

require "pry"

module ShippingCalculator
  # This class prints a transaction of type PackageDetail.
  #
  # TODO: needs testing
  class PrintTransaction
    def self.output_single_transaction(transaction)
      print "#{transaction.date} #{transaction.size} #{transaction.carrier} "
      print "#{price_paid_str(transaction)} #{discount_str(transaction)}\n"
    end

    def self.price_paid_str(transaction)
      price_paid = transaction.full_price - transaction.discount
      format("%.2f", (price_paid.to_f / 100.00))
    end

    def self.discount_str(transaction)
      if transaction.discount.zero?
        "-"
      else
        format("%.2f", (transaction.discount.to_f / 100.00))
      end
    end
  end
end
