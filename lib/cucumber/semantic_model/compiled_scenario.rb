require 'cucumber/semantic_model/node'

module Cucumber
  module SemanticModel
    # A CompiledScenario is an executable sequence of statements. Statements can
    # be hooks, background steps, scenario steps or expanded scenario outline steps
    # from table rows
    class CompiledScenario
      include Node
      def initialize(source_scenario)
        @source_scenario = source_scenario
      end
    end
  end
end
