require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    class StepContainer
      attr_accessor :steps
      attr_reader :keyword, :description, :line

      def initialize(keyword, description, line, parent)
        @keyword, @description, @line, @parent = keyword, description, line, parent
        @steps = []
      end
      
      def create_step(keyword, name, line)
        step = Step.new(keyword, name, line, nil)
        @steps << step
        step
      end
    end
  end
end
