require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Example < StepContainer
      include Comments
      include Tags
      include Description
      include Unit
      
      def initialize(table_row, line, steps, examples)
        description = table_row.values.join(" | ")
        super("Example", description, line, examples)
        @tags = examples.tags
        @steps = steps
      end
      
      def examples
        @parent
      end
      
      def from_outline?
        true
      end
      
      def feature
        examples.feature
      end
    
      def scenario_outline
        examples.scenario_outline
      end
    end
  end
end