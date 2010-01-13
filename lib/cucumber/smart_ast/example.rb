require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Example
      include Comments
      include Tags
      include Description
      
      def initialize(hash, line, examples)
        @hash, @line, @examples = hash, line, examples
        #description = hash.values.join(" | ")
      end

      def execute(step_mother, listener)
        step_mother.before(self)
        listener.before_unit(self)

        all_steps.each do |step|
          step.execute(step_mother, listener)
        end

        listener.after_unit(self)
        step_mother.after(self)
      end

      def report_to(gherkin_listener)
        @examples.report_to(gherkin_listener)
      end

      private

      def all_steps
        @examples.steps(@hash)
      end
    end
  end
end