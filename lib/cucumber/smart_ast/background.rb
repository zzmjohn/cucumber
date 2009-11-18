require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/steps'
require 'cucumber/smart_ast/py_strings'

module Cucumber
  module SmartAst
    class Background < StepContainer
      include Steps
      include PyStrings
    end
  end
end
