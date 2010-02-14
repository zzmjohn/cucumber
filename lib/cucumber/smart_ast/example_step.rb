module Cucumber
  module SmartAst
    class ExampleStep
      def initialize(keyword, name, line, columns, multiline_argument)
        @keyword, @name, @line, @columns, @multiline_argument = keyword, name, line, columns, multiline_argument
      end

      def execute(unit_result, step_mother)
        step_result = StepResult.new(unit_result, self)
        step_result.execute(step_mother, @name, @multiline_argument)
        step_result
      end

      def report_result(gherkin_listener, status, arguments, exception)
        # NO-OP
      end
    end
  end
end