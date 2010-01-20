module Cucumber
  module SmartAst
    class StepResult
      def initialize(status, step, exception=nil)
        @status, @step, @exception = status, step, exception
      end

      def accept(visitor)
        visitor.visit_step_result(self)
      end

      def report_to(gherkin_listener)
        @step.report_result(gherkin_listener, @status, @exception)
      end

      def failure?
        [:undefined, :pending, :failed].include?(@status)
      end
    end
  end
end
