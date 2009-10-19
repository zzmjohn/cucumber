require 'cucumber/new_ast/has_steps'
require 'cucumber/new_ast/examples'

module Cucumber
  module NewAst
    class ScenarioOutline < HasSteps
      def examples(keyword, name, line)
        Examples.new(keyword, name, line)
      end
    end
  end
end