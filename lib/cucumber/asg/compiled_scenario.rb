module Cucumber
  module Asg
    # A CompiledScenario is an executable sequence of statements. Statements can
    # be hooks, background steps, scenario steps or expanded scenario outline steps
    # from table rows
    class CompiledScenario
      def initialize(source_scenario, statements)
        @source_scenario = source_scenario
        @statements = statements
      end

      def accept(visitor)
        @statements.each do |statement|
          visitor.visit_statement(statement)
        end
      end
    end
  end
end