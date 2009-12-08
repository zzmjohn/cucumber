module Cucumber
  module SmartAst
    class Executor
      attr_accessor :options #:nodoc:
      attr_reader   :step_mother #:nodoc:

      def initialize(step_mother, listeners = [], options = {}, io = STDOUT)
        @step_mother, @listeners, @options, @io = step_mother, listeners, options, io
      end
      
      def execute(ast)
        ast.units.each do |unit|
          unit.execute(@step_mother) do |result|
            unit.skip_step_execution! if result.failure?
            puts result
          end
        end
      end
    end
  end
end
