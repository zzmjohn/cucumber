require 'cucumber/formatter/ansicolor'

module Cucumber
  module SmartAst
    class Executor
      include Formatter::ANSIColor
      attr_accessor :options #:nodoc:
      attr_reader   :step_mother #:nodoc:

      def initialize(step_mother, listeners = [], options = {}, io = STDOUT)
        @step_mother, @listeners, @options, @io = step_mother, listeners, options, io
      end
      
      def execute(ast)
        ast.units.each do |unit|
          unit.execute(@step_mother) do |result|
            unit.skip_step_execution! if result.failure?
            @io << colorize(result)
            @io.puts
          end
          @io.flush
        end
      end
      
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
  end
end
