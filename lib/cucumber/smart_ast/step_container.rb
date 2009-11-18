require 'cucumber/smart_ast/steps'
require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class StepContainer
      include Steps

      attr_reader :name, :description, :line
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
      end

      def table(rows, line)
        steps.last.argument = Table.new(rows, line)
      end

      def py_string(start_col, content, line)
        steps.last.argument = PyString.new(start_col, content, line)
      end
    end
  end
end
