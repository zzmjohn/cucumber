module Cucumber
  module SmartAst
    class Example < Scenario
      def initialize(table_row, line, examples)
        description = table_row.values.join(" | ")
        super("Example", description, line, examples.tags, examples.feature)
        @steps = examples.scenario_outline.generate_steps(table_row, examples.headers)
      end
      
      def examples
        @parent
      end
      
      def from_outline?
        true
      end
      
      def feature
        return examples.feature
      end
    
      def scenario_outline
        examples.scenario_outline
      end
    end
  end
end