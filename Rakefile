# frozen_string_literal: true

require "rspec/core/rake_task"
require "rubocop/rake_task"

task default: %i[test rubocop]

RSpec::Core::RakeTask.new(:test)
RuboCop::RakeTask.new(:rubocop)

task :run do
  # The arguments to the run task in the command line, need to be mader
  # empty tasks, otherwise rake complaints about tasks not existing, and exists.
  #
  ARGV.each do |a|
    task a.to_sym do
      # empty task
    end
  end
  # Assumes there is only one argument, the name of the data file.
  ruby "lib/shipping_calculator.rb #{ARGV[1]}"
end
