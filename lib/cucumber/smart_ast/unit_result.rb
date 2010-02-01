module Cucumber
  module SmartAst
    class UnitResult
      def initialize(unit)
        @unit = unit
      end
      
      def step_result!(step, status, exception)
        StepResult.new(step, status, exception)
      end

      def accept(visitor)
        visitor.visit_unit_result(self)
      end

      def report_to(gherkin_listener)
        @unit.report_result(gherkin_listener)
      end
    end
  end
end
