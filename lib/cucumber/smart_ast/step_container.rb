require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/step'
require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class StepContainer
      attr_accessor :feature, :steps
      attr_reader :name, :description, :line
      
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
        @steps = []
        yield self if block_given?
      end

      def step(adverb, name, line)
        step = Step.new(adverb, name, line)
        @steps << step
        step
      end

      def table(rows, line)
        steps.last.argument = Table.new(rows, line)
      end

      def py_string(start_col, content, line)
        steps.last.argument = PyString.new(start_col, content, line)
      end
            
      def language
        @feature.language
      end
      
      def accept_hook?(hook)
       true
      end
      
      def status
        :passed
      end
    end
  end
end
