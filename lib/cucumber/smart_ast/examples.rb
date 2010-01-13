require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples
      include Tags
      include Description
      
      attr_reader :keyword, :description, :line
      
      def initialize(keyword, description, line, tags, scenario_outline)
        @keyword, @description, @line, @tags, @scenario_outline = keyword, description, line, tags, scenario_outline
      end

      def table!(rows, line)
        table = Table.new(rows, line)
        table.hashes.each_with_index do |hash, row_index|
          yield Example.new(hash, table.line + row_index, self)
        end
      end

      def steps(hash)
        @scenario_outline.steps(hash)
      end

      def report_to(gherkin_listener)
        @scenario_outline.report_to(gherkin_listener)
      end
    end
  end
end
