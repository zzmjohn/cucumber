require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Examples < StepContainer
      include Tables
    end
  end
end
