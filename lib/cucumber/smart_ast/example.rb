module Cucumber
  module SmartAst
    class Example < Scenario
      def initialize(table_row, line, examples)
        description = table_row.values.join(" | ")
        super("Example", description, line, examples.tags, examples.feature)
        @steps = examples.scenario_outline.steps.map do |step| 
          step.interpolate(table_row, examples.headers)
        end
      end
    end
  end
end