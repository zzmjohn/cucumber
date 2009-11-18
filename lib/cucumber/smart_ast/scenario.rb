require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Comments
      include Tags
    end
  end
end
