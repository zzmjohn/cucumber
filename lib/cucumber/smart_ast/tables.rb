require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    module Tables
      attr_reader :tables
      def table(rows, line)
        @tables ||= []
        table = Table.new(rows, line)
        @tables << table
        table
      end
    end
  end
end
