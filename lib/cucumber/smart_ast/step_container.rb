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
      
      def add_step!(keyword, name, line)
        @steps << Step.new(keyword, name, line, self)
      end

      def language
        @parent.language
      end
    end
  end
end
