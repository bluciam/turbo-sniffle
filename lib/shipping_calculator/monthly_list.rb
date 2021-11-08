# frozen_string_literal: true

require "date"
require "./lib/shipping_calculator/package_detail"
require "./lib/shipping_calculator/print_transaction"

module ShippingCalculator
  # This class stores an array of records of class PackingDetail
  # in a calendar month and calculates shipping discounts for that month.
  #
  # The filters can be made a new class, more general, which can be used to
  # apply any type of discounts over different groupings (i.e. by year or any
  # other possible criteria).
  #
  class MonthlyList
    attr_reader :transactions, :prices
    attr_accessor :cumm_discount, :total_large_pkgs

    # TODO: these constants should be at module level, and the discounts can be
    # prefixed with monthly, in case there are new discounts.
    #
    # In cents
    MAX_DISCOUNT = 1000
    # Maximum number of packages free per month
    MAX_FREE_LARGE = 3

    PRICES = { "LP" => { "S" => 150,
                         "M" => 490,
                         "L" => 690 },
               "MR" => { "S" => 200,
                         "M" => 300,
                         "L" => 400 } }.freeze

    # @param input_lines [Array<Strings>] already grouped by month
    # @param [Hash, <String, [Hash<String, Int>]] the shipping price list in
    #        cents grouped by carrier and size
    #
    def initialize(input_lines, price_list = PRICES)
      @cumm_discount = 0
      @total_large_pkgs = 0
      @prices = price_list
      @transactions = parse_array(input_lines)
    end

    # Takes an array of strings and converts them to an array of type_detail
    # object, default is PackageDetail, if the string has the correct format.
    #
    # @param input_lines [Array<String>]
    # @param type_detail <Class>
    #
    # @return [Array<PackageDetail>]
    # @return empty array if input_lines is nil
    #
    def parse_array(input_lines, type_detail: PackageDetail)
      return [] if input_lines.to_a.empty?

      input_lines.map do |input_line|
        type_detail.new(input_line)
      end
    end

    # Completes the missing cost and discount attributes in the transactions.
    # It calls in turn each of the filters available for discount on each
    # transaction. When more filters are added, filtering can become its own
    # class.
    #
    # No filters are called when the max discount is reached. This assumes that
    # this method is only called once on an instance. Otherwise, the discount
    # will be overwritten.
    #
    def calculate_costs
      transactions.each do |transaction|
        next unless transaction.valid?

        transaction.full_price = prices[transaction.carrier][transaction.size]
        transaction.discount = 0
        transaction.end_price = transaction.full_price

        next if cumm_discount == MAX_DISCOUNT

        small_package(transaction)
        large_package(transaction)
      end
    end

    # Calculates the possible  discount when a package is small from a
    # different carrier to LaPoste. It calls set_discount for the actual
    # calculation and cumulative adjustments.
    #
    def small_package(transaction)
      return unless transaction.size == "S" && transaction.carrier != "LP"

      set_discount(50, transaction)
    end

    # Calculates the possible  discount when a package is large from LaPoste.
    # It adds to the cumulative total package.  It calls set_discount for
    # the actual calculation and cumulative adjustments.
    #
    def large_package(transaction)
      return unless transaction.size == "L" && transaction.carrier == "LP"

      @total_large_pkgs += 1

      return if total_large_pkgs != MAX_FREE_LARGE

      set_discount(transaction.full_price, transaction)
    end

    # This method takes a transaction and a possible discount, and depending on
    # MAX_DISCOUNT, cumm_discount, and the transaction.full_price, updates the
    # latter, cumm_discount and the transaction counters: discount and
    # end_price.
    #
    def set_discount(possible_discount, transaction)
      if (MAX_DISCOUNT - cumm_discount - possible_discount).positive?
        # puts "full discount"
        transaction.discount = possible_discount
        transaction.end_price = transaction.full_price - transaction.discount
        @cumm_discount += possible_discount
      else
        # puts "part discount"
        available = MAX_DISCOUNT - cumm_discount
        transaction.discount = available
        transaction.end_price = transaction.full_price - available
        @cumm_discount += available
      end
    end

    # Iterates through the list of transactions and prints results for each.
    def discounted_list
      transactions.each do |transaction|
        unless transaction.valid?
          puts "#{transaction.original} Ignored"
          next
        end

        PrintTransaction.output_single_transaction(transaction)
      end
    end
  end
end
