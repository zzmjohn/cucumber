require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class Step
      attr_reader :keyword, :name, :line, :argument
      
      def initialize(keyword, name, line, argument)
        @keyword, @name, @line, @argument = keyword, name, line, argument
      end

      def table!(rows, line)
        @argument = Table.new(rows, line)
      end

      def py_string!(content, line)
        @argument = PyString.new(content, line)
      end

      def accept_for_argument(visitor)
        @argument.accept(visitor) if @argument
      end
      
      def execute(step_mother, listener)
        listener.before_step(self)
        e, status = step_mother.invoke2(@name, @argument)
        result = StepResult.new(status, self, e)
        listener.after_step(result)
        step_mother.after_step # TODO: Feels weird to not pass self.
      end

      def report_result(gherkin_listener, status, exception)
        gherkin_listener.step(@keyword, @name, @line) # TODO: The extra info so listener can colorize and print comment
        @argument.report_to(gherkin_listener) if @argument
      end
      
      def ==(obj)
        raise "WHERE IS THIS USED??"
        @name == obj.name
      end
    end
  end
end
