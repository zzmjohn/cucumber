require 'cucumber/smart_ast/example_step'

module Cucumber
  module SmartAst
    # Children of ScenarioOutline.
    class StepTemplate
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end

      def table!(rows, line)
        @argument = Table.new(rows, line)
      end

      def py_string!(content, line)
        @argument = PyString.new(content, line)
      end

      def create_example_step(keys, values, line)
        columns = []

        name = @name.dup
        keys.each_with_index do |key, n|
          # TODO: Use zip?
          if replace(key, values[n], name)
            columns << n
          end
        end

        ExampleStep.new(@keyword, name, line, columns, @argument)
      end

      def report_to(gherkin_listener)
        # TODO: pass extra position arguments so we can highlight the arguments
        gherkin_listener.step(@keyword, @name, @line)
        @argument.report_to(gherkin_listener) if @argument
      end

    private

      def replace(key, value, name)
        if name =~ /<#{key}>/
          name.gsub!(/<#{key}>/, value)
          true
        end
      end
    end
  end
end
