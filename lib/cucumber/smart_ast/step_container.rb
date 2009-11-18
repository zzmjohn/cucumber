require 'cucumber/smart_ast/steps'
require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/py_strings'
require 'cucumber/smart_ast/tables'

module Cucumber
  module SmartAst
    class StepContainer
      attr_reader :name, :description, :line
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
      end
    end
  end
end
