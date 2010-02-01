require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    # An Example instance is created for each non-header row in an Examples
    # table
    class Example
      include Comments
      include Tags
      include Description

      def initialize(example_steps, row_index, examples)
        @example_steps, @row_index, @examples = example_steps, row_index, examples
      end

      def execute(step_mother, listener)
        step_mother.execute_unit(self, @example_steps, listener)
      end

      def accept(visitor)
        @examples.accept(visitor)
        visitor.visit_example(self)
      end

      def report_to(gherkin_listener)
        # NO-OP
      end

      def report_result(gherkin_listener)
        @examples.report_result(gherkin_listener, @row_index)
      end
    end
  end
end