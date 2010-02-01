require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class ScenarioStep
      attr_reader :name, :argument
      
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end

      def table!(rows, line)
        @argument = Table.new(rows, line)
      end

      def py_string!(content, line)
        @argument = PyString.new(content, line)
      end

      def report_result(gherkin_listener, status, exception)
        gherkin_listener.step(@keyword, @name, @line) # TODO: The extra info so listener can colorize and print comment
        @argument.report_to(gherkin_listener) if @argument
      end
    end
  end
end
