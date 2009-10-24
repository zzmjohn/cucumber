module Cucumber
  module Asg
    class CompiledStep
      def initialize(ast_node)
        @ast_node = ast_node
      end

      def announce
        puts "  #{@ast_node.keyword} #{@ast_node.name}"
      end
    end
  end
end