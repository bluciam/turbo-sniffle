# frozen_string_literal: true

require_relative "shipping_calculator/version"
require "./lib/shipping_calculator/shipping_calculator"

# This module encompases all the classes and methods needed for parsing an
# input text file containing shipping information, calculates the discounts
# that need to be applied according to set varaibles and prints the resulting
# list.
#
# When loading, it grabs the first arguement assumed to be the file name, and
# calls the run method on the class to start processing. Exists if no file
# name is given.
#
module ShippingCalculator
  file_name = ARGV.first

  if file_name
    ShippingCalculator.run(file_name)
  else
    puts "Filename must be provided and must be first argument."
  end
end
