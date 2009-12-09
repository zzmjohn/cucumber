require 'cucumber/formatter/ansicolor'
require 'cucumber/smart_ast/unit'

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
        ast.all_scenarios.each do |scenario|
          unit = Unit.new(ast.background_steps + scenario.steps, (ast.tags + scenario.tags).uniq, scenario.language)
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
