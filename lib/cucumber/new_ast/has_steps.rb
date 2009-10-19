require 'cucumber/new_ast/step'

module Cucumber
  module NewAst
    class HasSteps
      def initialize(keyword, name, line)
        @steps = []
      end
      
      def step(keyword, name, line)
        step = Step.new(keyword, name, line)
        @steps << step
        step
      end
    end
  end
end