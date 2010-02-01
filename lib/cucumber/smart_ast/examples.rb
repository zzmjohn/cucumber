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
        @rows[1..-1].each_with_index do |row, row_index|
          yield @scenario_outline.create_example(@rows[0], row, line+=1, row_index+1, self)
        end
      end

      def accept(visitor)
        @scenario_outline.accept(visitor)
        visitor.visit_examples(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.examples(@keyword, @description, @line)
        gherkin_listener.table(@rows, @table_line, [@rows[0]], 0)
      end

      def execute(row, step_mother, listener)
        @scenario_outline.execute(@rows[0], row, step_mother, listener)
      end

      def report_result(gherkin_listener, row_index)
        # TODO: Accumulate results, and only invoke table when we have
        # received the same number of calls as outline has step_templates
        # Maybe we need to delegate to scenario_outline as it has the best
        # knowledge of that count. Also need to colour rows properly.
        # Colouring is output specific (pretty, html and pdf do it differently),
        # so ANSI colouring should maybe go to gherkin pretty formatter.
        
        # We're passing 0 as line. If we need it, each example should store it as a field
        
        # TODO: Pass row and row_index directly so we don't need accessors
        row = @rows[row_index]

        gherkin_listener.table(@rows, @table_line+row_index, [row], row_index)
      end
    end
  end
end
