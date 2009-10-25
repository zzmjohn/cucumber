module Cucumber
  module Asg
    # A CompiledScenario is an executable sequence of statements. Statements can
    # be hooks, background steps, scenario steps or expanded scenario outline steps
    # from table rows
    class CompiledScenario
      def initialize(ast_node, statements)
        @ast_node = ast_node
        @statements = statements
      end

      def announce
        puts "#{@ast_node.keyword}: #{@ast_node.name}"
      end

      def accept(visitor)
        @statements.each do |statement|
          visitor.visit_statement(statement)
        end
      end
    end
  end
end