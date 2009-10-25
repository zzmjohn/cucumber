module Cucumber
  module Asg
    # Executes the Asg by walking it
    class Runtime
      def execute(compiled_feature)
        compiled_feature.accept(self)
      end

      def visit_scenario(compiled_scenario)
        compiled_scenario.announce
        compiled_scenario.accept(self)
      end

      def visit_statement(statement)
        statement.announce
        # TODO: do some invoke action
      end
    end
  end
end