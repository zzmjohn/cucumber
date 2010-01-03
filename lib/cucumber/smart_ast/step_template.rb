require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    class StepTemplate < Step
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
        Step.new(@keyword, name, @line, @container, argument)
      end
    end
  end
end
