require 'cucumber/formatter/ansicolor'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class SimpleFormatter
      include Formatter::ANSIColor
      def initialize(_,io,__)
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
  end
end
