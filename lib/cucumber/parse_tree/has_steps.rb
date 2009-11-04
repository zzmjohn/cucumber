require 'cucumber/parse_tree/step'

module Cucumber
  module ParseTree
    class HasSteps
      attr_reader :keyword, :name, :line
      
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
        @steps = []
      end
      
      def step(keyword, name, line)
        step = Step.new(keyword, name, line)
        @steps << step
        step
      end

      def accept(visitor)
        @steps.each do |step|
          visitor.visit_step(step)
        end
      end
    end
  end
end
