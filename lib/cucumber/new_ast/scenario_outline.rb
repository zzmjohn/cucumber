require 'cucumber/new_ast/has_steps'
require 'cucumber/new_ast/examples'

module Cucumber
  module NewAst
    class ScenarioOutline < HasSteps
      def examples(keyword, name, line)
        examples = Examples.new(keyword, name, line)
        all_examples << examples
        examples
      end

      def accept(visitor)
        super
        all_examples.each do |examples|
          visitor.visit_examples(examples)
        end
      end

      private
      
      def all_examples
        @all_examples ||= []
      end
    end
  end
end
