require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples
      include Tags
      include Description
      
      def initialize(keyword, description, line, tags, scenario_outline)
        @keyword, @description, @line, @tags, @scenario_outline = keyword, description, line, tags, scenario_outline
      end

      def table!(rows, line)
        @rows = rows
        @table_line = line
        rows[1..-1].each_with_index do |row, row_index|
          yield Example.new(self, row, row_index+1)
        end
      end

      def execute_example(example, step_mother, listener)
        hash = Hash[[@rows[0], example.row].transpose]
        @scenario_outline.example_steps(example, hash).each do |example_step|
          example_step.execute(step_mother, listener)
        end
      end

      def example_steps(example, hash)
        @scenario_outline.example_steps(example, hash)
      end

      def accept(visitor)
        @scenario_outline.accept(visitor)
        visitor.visit_examples(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.examples(@keyword, @description, @line)
        gherkin_listener.table(@rows, @table_line, [@rows[0]], 0)
      end

      def report_result(gherkin_listener, example, status, exception)
        # TODO: Accumulate results, and only invoke table when we have
        # received the same number of calls as outline has step_templates
        # Maybe we need to delegate to scenario_outline as it has the best
        # knowledge of that count. Also need to colour rows properly.
        # Colouring is output specific (pretty, html and pdf do it differently),
        # so ANSI colouring should maybe go to gherkin pretty formatter.
        
        # We're passing 0 as line. If we need it, each example should store it as a field
        gherkin_listener.table(@rows, 0, [example.row], example.row_index)
      end
    end
  end
end
