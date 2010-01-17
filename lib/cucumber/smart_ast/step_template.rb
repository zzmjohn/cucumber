require 'cucumber/smart_ast/example_step'

module Cucumber
  module SmartAst
    # Children of ScenarioOutline.
    class StepTemplate
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end
      
      def example_step(example_cells)
        #raise "continue here"
        # name = @name.dup
        # matched_args = []
        # hash.each do |key, value|
        #   if name =~ /<#{key}>/
        #     name.gsub!(/<#{key}>/, value)
        #     matched_args << value
        #   end
        # end
        # argument = @argument ? @argument.interpolate(hash) : nil
        
        # TODO: pass self? We usually do...
        ExampleStep.new(self, example_cells)
      end

      def report_to(gherkin_listener)
        gherkin_listener.step(@keyword, @name, @line)
        @argument.report_to(gherkin_listener) if @argument
      end

    end
  end
end
