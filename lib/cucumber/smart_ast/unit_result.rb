module Cucumber
  module SmartAst
    class UnitResult
      attr_reader :unit
      
      def initialize(unit, statuses)
        @unit = unit
        @statuses = statuses
      end
      
      def steps
        @unit.steps
      end
      
      def step_result(step)
        @statuses[step]
      end
    end
  end
end
