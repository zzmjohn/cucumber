module Cucumber
  module SmartAst
    class PyString
      def initialize(content, line)
        @content, @line = content, line
      end
      
      def self.default_arg_name
        "string"
      end

      def accept(visitor)
        visitor.py_string(self)
      end

      def to_s
        @content.gsub(/\\"/, '"')
      end
      
      def to_execution_format
        to_s
      end

      def interpolate(hash) #:nodoc:
        string = @content
        hash.each do |key, value|
          value ||= ''
          string = string.gsub(/<#{key}>/, value)
        end
        self.class.new(string, @line)
      end

      def has_text?(text)
        @content.index(text)
      end      
    end
  end
end
