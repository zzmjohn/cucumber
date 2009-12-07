module Cucumber
  module SmartAst
    class Executor
      attr_accessor :options #:nodoc:
      attr_reader   :step_mother #:nodoc:

      def initialize(step_mother, listeners = [], options = {}, io = STDOUT)
        @step_mother, @listeners, @options, @io = step_mother, listeners, options, io
      end
      
      def execute(ast)
        background = ast.background
        
        if background
          background.steps.each do |step|
            puts step
          end
        end
        
        ast.units.each do |unit|
          unit.steps.unshift(background.steps) if background          
          @step_mother.execute(unit)
          unit.steps.each do |step|
            puts step
          end
        end        
      end            
    end
  end
end
