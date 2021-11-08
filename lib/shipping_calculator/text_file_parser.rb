# frozen_string_literal: true

require "./lib/shipping_calculator/process_by_group"

module ShippingCalculator
  # Takes an input and parses it according to type.
  # The only type supported now is :txt_file.
  # Exists when the input_type is not implemented.
  #
  # @param input [File]
  # @param input_type [Symbol] type of file expected
  # @param process_method [Class] class to process data by criteria
  #
  # @raise error when input is not an exisitng file.
  #
  class TextFileParser
    def self.run(input, input_type: :txt_file, process_method: ProcessByGroup)
      unless input_type == :txt_file
        puts "Parsing of type #{input_type} is not implemented yet."
        return
      end

      raise "File must exist" unless File.exist?(input)

      lines = File.readlines(input)
      process_method.run(lines, group: :by_month)
    end
  end
end
