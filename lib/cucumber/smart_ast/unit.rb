require 'cucumber/smart_ast/result'

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

      def skip_step_execution!
        @skip = true
      end

      def execute(step_mother, &block)
        step_mother.before_and_after(self) do
          steps.each do |step|
            if @skip
              yield Result.new(:skipped, step)
            else
              yield step_mother.execute(step)
            end
          end
        end
      end
    end
  end
end
