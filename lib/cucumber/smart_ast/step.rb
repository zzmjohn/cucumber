require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class Step
      attr_reader :keyword, :name, :line, :argument
      
      def initialize(keyword, name, line, container, argument=nil)
        @keyword, @name, @line, @container, @argument = keyword, name, line, container, argument
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
      
      def to_execution_format
        [@name, @argument ? @argument.to_execution_format : nil]
      end
      
      def ==(obj)
        @name == obj.name
      end
      
      def to_s
        "#{@keyword} #{@name}"
      end
    end
  end
end
