require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Unit 
      attr_reader :steps, :language

      def initialize(steps, language)
        @steps, @language = steps, language
      end

      def accept_hook?(hook)
        true
      end
      
      def status
        :passed
      end
      
      def fail!(exception)
        puts "#{@name}: #{@description} failed!"
        raise exception
      end
      
      def name
        "#{@kw}: #{@description}"
      end

      def execute(step_mother, &block)
        step_mother.before_and_after(self) do
          steps.each do |step|
            begin
              step_mother.invoke(step.name, (step.argument.to_s if step.argument))
              yield "Passed: #{step}"
            rescue Pending
              yield "Pending: #{step}"
            rescue Undefined
              yield "Undefined: #{step}"
            rescue Exception
              yield "Failed: #{step}"
            end
          end
        end
      end
    end
  end
end
