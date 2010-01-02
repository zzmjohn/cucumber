module Cucumber
  module SmartAst
    class Run
      def initialize(listeners, step_mother = StepMother.new)
        @listeners = listeners.extend(ListenersBroadcaster)
        @step_mother = step_mother
      end
      
      def execute(units)
        units.each do |unit|
          unit.execute(self)
        end
      end
      
      def after_unit(unit_result)
        
      end
      
      def before_unit(unit)
        
      end
      
      def before_step(step)
        
      end
      
      def after_step(step_result)
        
      end
    end
  end
end