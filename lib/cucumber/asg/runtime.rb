module Cucumber
  module Asg
    # Executes the Asg by walking it
    #
    # TODO Gherkin. We should probably keep track of backends (RbLanguage etc),
    # since we're interacting with it directly.
    class Runtime
      def initialize(step_mother)
        @step_mother = step_mother
      end

      def execute(compiled_feature)
        visit_compiled_feature(compiled_feature)
      end

      def visit_compiled_feature(compiled_feature)
        compiled_feature.accept(self)
      end

      def visit_compiled_scenario(compiled_scenario)
        @compiled_scenario = compiled_scenario
        compiled_scenario.accept(self)
      end

      def visit_statement(statement)
        # TODO - visit to get any tables or pystrings
        statement.invoke(@step_mother, @compiled_scenario)
      end
    end
  end
end