require 'cucumber/semantic_model/node'

module Cucumber
  module SemanticModel
    class CompiledHook
      include Node

      def initialize(language_hook, step_mother)
        @hook = language_hook
        @step_mother = step_mother
      end

      def invoke
        @hook.invoke(@step_mother, @parent) # Can we get rid of the need for stepmother here?
      end
 
      def name
        @ast_node.name
      end
    end
  end
end
