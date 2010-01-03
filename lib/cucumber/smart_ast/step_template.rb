require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    class StepTemplate < Step
      def interpolate(args, headers)
        name = @name.dup
        matched_args = []
        headers.each do |key|
          value = args[key]
          if name =~ /<#{key}>/
            name.gsub!(/<#{key}>/, value)
            matched_args << value
          end
        end
        step = Step.new(@keyword, name, @line, @container, matched_args)
        step.argument = @argument if @argument
        step
      end
    end
  end
end
