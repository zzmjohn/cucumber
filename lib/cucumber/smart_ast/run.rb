module Cucumber
  module SmartAst
    class Run
      def initialize(listeners, step_mother = StepMother.new)
        @listeners = listeners.extend(ListenersBroadcaster)
        @step_mother = step_mother
      end
      
      def execute_step(step, unit)
        @step_mother.execute(step, unit)
      end
      
      def execute(units)
        units.each do |unit|
          before_unit(unit)
          result = unit.execute(self)
          after_unit(result)
        end
      end
      
      def before_unit(unit)
        @step_mother.before(unit)
        @listeners.before_unit(unit)
      end
      
      def after_unit(unit_result)
        @listeners.after_unit(unit_result)
        @step_mother.after(unit_result.unit)
      end
      
      def before_step(step)
        @listeners.before_step(step)
      end
      
      def after_step(step_result)
        @listeners.after_step(step_result)
      end
    end
  end
end