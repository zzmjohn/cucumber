require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Enumerable
      include Comments
      include Tags
      
      def each(&block)
        @steps.each { |step| yield step }
      end
    end
  end
end
