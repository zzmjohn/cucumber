require 'cucumber/formatter/ansicolor'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Executor
      class SimpleFormatter
        include Formatter::ANSIColor
        def initialize(io = STDOUT)
          @io = io
        end
        
        def after_step(result)
          @io << colorize(result)
          @io.puts
        end
        
        private
        
        def colorize(result)
          str = result.to_s
          case result.status
          when :passed
            green(str)
          when :pending || :undefined
            yellow(str)
          when :skipped
            cyan(str)
          when :failed
            red(str)
          else
            grey(str)
          end
        end
      end
      
      attr_accessor :options #:nodoc:
      attr_reader   :step_mother #:nodoc:

      def initialize(step_mother, listeners = [], options = {}, io = STDOUT)
        @step_mother, @listeners, @options, @io = step_mother, listeners, options, io
        @listeners << SimpleFormatter.new
        @listeners.extend(ListenersBroadcaster)
      end
      
      def execute(ast)
        @listeners.before_feature(ast)
        all_units(ast).each do |unit|
          unit.execute(@step_mother, @listeners)
        end
        @listeners.after_feature(ast)
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
