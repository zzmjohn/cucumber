require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Steps
      include PyStrings
      include Comments
      include Tags
      include Tables
    end
  end
end
