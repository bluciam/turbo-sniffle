# frozen_string_literal: true

require "date"

module ShippingCalculator
  # This class stores and validates entry lines of shipment transactions
  #
  class PackageDetail
    attr_reader :size, :date, :carrier, :original
    attr_accessor :full_price, :discount, :end_price

    def initialize(input_line)
      @original = input_line.strip
      @date, @size, @carrier = input_line.split

      @date = nil unless valid_date?
      @size = nil unless valid_size?
      @carrier = nil unless valid_carrier?
    end

    def valid_date?
      return unless date

      y, m, d = date.split "-"
      Date.valid_date? y.to_i, m.to_i, d.to_i
    end

    def valid_size?
      return unless size

      %w[S M L].include? size
    end

    def valid_carrier?
      return unless carrier

      %w[LP MR].include? carrier
    end

    def valid?
      date && size && carrier
    end
  end
end
