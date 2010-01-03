module Cucumber
  module SmartAst
    class UnitResult
      attr_reader :unit
      
      def initialize(unit, step_results)
        @unit = unit
        @step_results = step_results
      end
      
      def steps
        @unit.steps
      end
      
      def step_result(step)
        @step_results.find{ |r| r.step === step }
      end
    end
  end
end
