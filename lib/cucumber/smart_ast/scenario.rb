require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Comments
      include Tags
      include Description
      include Unit
      
      def initialize(keyword, description, line, tags, feature)
        super(keyword, description, line, feature)
        @tags = tags + feature.tags
      end
    end
  end
end
