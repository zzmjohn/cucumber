require 'cucumber/new_ast/ast_node'

module Cucumber
  module NewAst
    # A CompiledScenario is an executable sequence of statements. Statements can
    # be hooks, background steps, scenario steps or expanded scenario outline steps
    # from table rows
    class CompiledScenario
      include AstNode
      def initialize(source_scenario)
        @source_scenario = source_scenario
      end
    end
  end
end
