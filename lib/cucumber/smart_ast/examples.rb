require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      
      attr_writer :steps, :feature
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
        yield self if block_given?
      end

      def table(rows, line)
        @table = Table.new(rows, line)
      end
      
      def scenarios
        scenarios = []
        @table.each_with_index do |row, idx|
          scenarios << Scenario.new("Scenario", row.values.join(" | "), @table.line + idx) do |scenario|
            scenario.feature = @feature
            scenario.steps = @steps.collect { |step| step.interpolate(row) }
          end
        end
        scenarios
      end
    end
  end
end
