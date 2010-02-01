module Cucumber
  module SmartAst
    class StepResult
      def initialize(step, status, exception)
        @step, @status, @exception = step, status, exception
      end

      def accept(visitor)
        visitor.visit_step_result(self)
      end

      def report_to(gherkin_listener)
        @step.report_result(gherkin_listener, @status, @exception)
      end
    end
  end
end
