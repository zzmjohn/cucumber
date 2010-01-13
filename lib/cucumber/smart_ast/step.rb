require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class Step
      attr_reader :keyword, :name, :line, :argument
      
      def initialize(keyword, name, line, argument, step_template=nil)
        @keyword, @name, @line, @argument, @step_template = keyword, name, line, argument, step_template
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

        e = nil
        status =
          begin
            step_mother.invoke(*to_execution_format)
            :passed
          rescue Undefined
            :undefined
          rescue Pending
            :pending
          rescue Exception => ex
            e = ex
            :failed
          end
        result = StepResult.new(status, self, e)
        listener.after_step(result)
        step_mother.after_step # TODO: Feels weird to not pass self.
      end

      def report_to(gherkin_listener, status, exception)
        if(@step_template)
          @step_template.report_to(gherkin_listener, status, exception)
        else
          gherkin_listener.step(@keyword, @name, @line) # TODO: The extra info so listener can colorize and print comment
          @argument.report_to(gherkin_listener) if @argument
        end
      end
      
      def ==(obj)
        @name == obj.name
      end

      private

      def to_execution_format
        [@name, @argument ? @argument.to_execution_format : nil]
      end

    end
  end
end
