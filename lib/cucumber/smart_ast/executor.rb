require 'cucumber/formatter/ansicolor'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Executor
      attr_accessor :options #:nodoc:
      attr_reader   :step_mother #:nodoc:

      def initialize(step_mother, listeners = [], options = {}, io = STDOUT)
        @step_mother, @listeners, @options, @io = step_mother, listeners, options, io
        @listeners.extend(ListenersBroadcaster)
      end
      
      def execute(ast)
        all_units(ast).each do |unit|
          unit.execute(@step_mother, @listeners)
        end
      end
      
      private
      
      def all_units(ast)
        ast.all_scenarios.map do |scenario|
          Unit.new(scenario)
        end
      end
      
    end
  end
end
