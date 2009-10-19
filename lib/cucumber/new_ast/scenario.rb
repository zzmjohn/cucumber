require 'cucumber/new_ast/step'
require 'cucumber/asg/unit'

module Cucumber
  module NewAst
    class Scenario
      def initialize(keyword, name, line)
        @steps = []
      end
      
      def step(keyword, name, line)
        step = Step.new(keyword, name, line)
        @steps << step
        step
      end
      
      def execute
        unit = Asg::Unit.new(self)
        unit.execute
      end
    end
  end
end