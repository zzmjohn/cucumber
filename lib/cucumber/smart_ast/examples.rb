require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      
      attr_reader :table
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
      end

      def table(rows, line)
        @table = Table.new(rows, line)
      end
    end
  end
end
