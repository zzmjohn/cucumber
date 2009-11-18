require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Examples < StepContainer
      attr_reader :argument
      def table(rows, line)
        @argument = Table.new(rows, line)
      end
    end
  end
end
