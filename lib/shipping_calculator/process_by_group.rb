# frozen_string_literal: true

require "./lib/shipping_calculator/monthly_list"

require "pry"

module ShippingCalculator
  # This class takes an array of strings where the first substring is an ISO
  # date, and splits it according to a criteria. The class gathers the
  # different methods to group by date.
  #
  class ProcessByGroup
    # Takes an array of lines and splits it in groups according
    # to a criteria. The only criteria supported now is :by_month.
    #
    # @param lines [Array<String>]
    # @param group <Symbol> defines on what criteria is the group split
    #
    def self.run(lines, group: :by_month)
      unless group == :by_month
        puts "Processing of group by #{group} is not implemented yet"
        return
      end

      # grouped_by_month = send(group, lines)
      grouped_by_month = by_month(lines)
      process_by_month(grouped_by_month)
    end

    # Creates a hash where the keys are the months and the values are arrays
    # of entries in that month.
    #
    # @param lines [Array<String>]
    # @raise error if the first string of the line is not a date of the form
    # yyyy-mm-dd + space.
    #
    def self.by_month(lines)
      lines.group_by do |line|
        date, = line.split(" ", 2)
        year, month, _day = date.split "-"
        "#{year}#{month}"
      end
    end

    # Takes a grouped hash, calculates costs according the month criteria
    # and prints out the results. Ignores object when the key is nil.
    #
    # @param grouped_by_month [Hash<String, [Array<String>]
    #
    def self.process_by_month(grouped_by_month)
      grouped_by_month.each do |month, monthly_list_input|
        next if month.nil?

        monthly_list = MonthlyList.new(monthly_list_input)
        monthly_list.calculate_costs
        monthly_list.discounted_list
      end
    end
  end
end
