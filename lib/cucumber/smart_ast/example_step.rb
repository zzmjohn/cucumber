module Cucumber
  module SmartAst
    class ExampleStep
      attr_reader :name, :argument
      
      # TODO: pass argument to ctor.
      def initialize(keyword, name, line, columns, argument)
        @keyword, @name, @line, @columns, @argument = keyword, name, line, columns, argument
      end

      def report_result(gherkin_listener, status, exception)
        # NO-OP
      end
    end
  end
end