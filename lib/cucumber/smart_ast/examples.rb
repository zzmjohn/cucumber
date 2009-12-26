require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      
      attr_writer :steps
      attr_reader :parent
      def initialize(keyword, description, line, parent)
        @keyword, @description, @line, @parent = keyword, description, line, parent
      end

      def table(table)
        @table = table
      end
      
      def name
        "#{@keyword}: #{@description}"
      end
      
      def scenarios
        scenarios = []
        @table.hashes.each_with_index do |row, idx|
          scenario = Scenario.new("Scenario", row.values.join(" | "), @table.line + idx, @parent)
          scenario.steps = @steps.collect { |step| step.interpolate(row) }
          scenarios << scenario
        end
        scenarios
      end
    end
  end
end
