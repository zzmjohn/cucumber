require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    class StepTemplate
      def initialize(keyword, name, line, scenario_outline, argument)
        @keyword, @name, @line, @scenario_outline, @argument = keyword, name, line, scenario_outline, argument
      end
      
      def interpolate(hash)
        name = @name.dup
        matched_args = []
        hash.each do |key, value|
          if name =~ /<#{key}>/
            name.gsub!(/<#{key}>/, value)
            matched_args << value
          end
        end
        argument = @argument ? @argument.interpolate(hash) : nil
        Step.new(@keyword, name, @line, argument, self)
      end

      def report_to(gherkin_listener, status, exception)
        gherkin_listener.step(@keyword, @name, @line) # TODO: The extra info so listener can colorize and print comment
        @argument.report_to(gherkin_listener) if @argument
      end

    end
  end
end
