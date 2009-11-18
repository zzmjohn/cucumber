require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    module Steps
      attr_reader :steps
      def step(adverb, body, line)
        @steps ||= []
        step = Step.new(adverb, body, line)
        @steps << step
        step
      end
    end
  end
end
