require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/steps'

module Cucumber
  module SmartAst
    class Background < StepContainer
      include Steps
    end
  end
end
