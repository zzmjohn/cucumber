module Cucumber
  module SmartAst
    class PyString
      def initialize(content, line)
        @content, @line = content, line
      end
      
      # copied from ast/py_string and modified
      attr_accessor :file

      def self.default_arg_name
        "string"
      end

      def accept(visitor)
        visitor.visit_py_string(self)
      end

      def to_s
        @content.gsub(/\\"/, '"')
      end
      
      def to_execution_format
        to_s
      end

      # def accept(visitor)
      #   return if Cucumber.wants_to_quit
      #   visitor.visit_py_string(to_s)
      # end
      
      def arguments_replaced(arguments) #:nodoc:
        string = @content
        arguments.each do |name, value|
          value ||= ''
          string = string.gsub(name, value)
        end
        self.class.new(string, @start_line)
      end

      def has_text?(text)
        @content.index(text)
      end      
    end
  end
end
