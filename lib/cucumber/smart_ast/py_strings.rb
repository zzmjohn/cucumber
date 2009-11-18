require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    module PyStrings
      attr_reader :py_strings
      def py_string(start_col, content, line)
        @py_strings ||= []
        py_string = PyString.new(start_col, content, line)
        @py_strings << py_string
        py_string
      end
    end
  end
end
