require 'cucumber/smart_ast/example_step'

module Cucumber
  module SmartAst
    # Children of ScenarioOutline.
    class StepTemplate
      def initialize(keyword, name, line, scenario_outline, argument)
        @keyword, @name, @line, @scenario_outline, @argument = keyword, name, line, scenario_outline, argument
      end
      
      def example_step(example, hash)
        name = @name.dup
        matched_args = []
        hash.each do |key, value|
          if name =~ /<#{key}>/
            name.gsub!(/<#{key}>/, value)
            matched_args << value
          end
        end
        argument = @argument ? @argument.interpolate(hash) : nil
        ExampleStep.new(example, name, argument)
      end

      def report_to(gherkin_listener)
        gherkin_listener.step(@keyword, @name, @line)
        @argument.report_to(gherkin_listener) if @argument
      end

    end
  end
end
