require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/step'
require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class StepContainer
      attr_accessor :steps
      attr_reader :kw, :description, :line, :parent

      def initialize(kw, description, line, parent)
        @kw, @description, @line, @parent = kw, description, line, parent
        @steps = []
      end

      def step(adverb, name, line)
        step = Step.new(adverb, name, line)
        @steps << step
        step
      end

      def table(rows, line)
        steps.last.argument = Table.new(rows, line)
      end

      def py_string(content, line)
        steps.last.argument = PyString.new(content, line)
      end         

      def feature
        @parent
      end

      def language
        feature.language
      end
    end
  end
end
