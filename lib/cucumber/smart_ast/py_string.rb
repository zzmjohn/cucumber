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

      # def initialize(start_line, end_line, string, quotes_indent)
      #   @start_line, @end_line = start_line, end_line
      #   @string, @quotes_indent = string.gsub(/\\"/, '"'), quotes_indent
      # end

      def to_s
        @content.gsub(/\\"/, '"')
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
        PyString.new(string, @start_line)
      end

      def has_text?(text)
        @content.index(text)
      end      
    end
  end
end
