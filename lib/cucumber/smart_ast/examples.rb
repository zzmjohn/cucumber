require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      
      attr_writer :steps
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
      end

      def table(rows, line)
        @table = Table.new(rows, line)
      end
      
      def scenarios
        scenarios = []
        @table.each_with_index do |row, idx|
          scenario = Scenario.new("Scenario", row.values.join(" | "), @table.line + idx)
          scenario.steps = @steps.collect { |step| step.interpolate(row) }
          scenarios << scenario
        end
        scenarios
      end
    end
  end
end
