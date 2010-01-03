module Cucumber
  module SmartAst
    class Step
      attr_accessor :argument
      attr_reader :keyword, :name, :line, :interpolated_args
      
      def initialize(keyword, name, line, container, interpolated_args = [])
        @keyword, @name, @line, @container, @interpolated_args = keyword, name, line, container, interpolated_args
      end
      
      def accept_for_argument(visitor)
        argument.accept(visitor) if argument
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
