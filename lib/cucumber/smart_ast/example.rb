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

      attr_reader :row, :row_index

      def initialize(examples, row, row_index)
        @examples, @row, @row_index = examples, row, row_index
      end

      def execute(step_mother, listener)
        # TODO: step_mother.execute_unit(listener, all_steps)
        step_mother.before(self)
        listener.before_unit(self)

        @examples.execute_example(self, @row, step_mother, listener)

        listener.after_unit(self)
        step_mother.after(self)
      end

      def accept(visitor)
        @examples.accept(visitor)
        visitor.visit_example(self)
      end

      def report_result(gherkin_listener, status, exception)
        @examples.report_result(gherkin_listener, self, status, exception)
      end

      def report_to(gherkin_listener)
        # NO-OP
      end
    end
  end
end