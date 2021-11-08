# frozen_string_literal: true

require "./lib/shipping_calculator/text_file_parser"

module ShippingCalculator
  # This class checks that the file provided in the input exists and
  # calls the appropriate parser.
  #
  class ShippingCalculator
    #
    # Parses an input using parser_type.
    # parser_type default's value is TextFileParser.
    #
    # @param input [File]
    # @param parser_type [Class] class responsible for parsing input
    #
    # @raise error if file does not exist.
    #
    def self.run(input, parser_type: TextFileParser)
      parser_type.run(input, input_type: :txt_file)
    end
  end
end
