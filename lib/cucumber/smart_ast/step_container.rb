require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/step'
require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class StepContainer
      attr_reader :name, :description, :line, :steps
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
        @steps = []
      end

      def step(adverb, body, line)
        step = Step.new(adverb, body, line)
        @steps << step
        step
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
