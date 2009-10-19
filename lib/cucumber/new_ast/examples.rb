require 'cucumber/ast/table'

module Cucumber
  module NewAst
    class Examples
      def initialize(keyword, name, line)
      end

      def table(raw, line)
        @table = Ast::Table.new(raw)
      end

      def accept(visitor)
        visitor.visit_examples_table(@table)
      end
    end
  end
end