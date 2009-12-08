require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Unit 
      class Result
        attr_reader :status, :step

        def initialize(status, step)
          @status, @step = status, step
        end

        def to_s
          "#{status.to_s.capitalize}: #{step}"
        end

        def failure?
          [:undefined, :pending, :failed].include?(@status)
        end
      end

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

      def skip!
        @skip = true
      end

      def execute(step_mother, &block)
        step_mother.before_and_after(self) do
          steps.each do |step|
            if @skip
              yield Result.new(:skipped, step)
            else
              begin
                step_mother.invoke(step.name, (step.argument.to_s if step.argument))
                yield Result.new(:passed, step)
              rescue Pending
                yield Result.new(:pending, step)
              rescue Undefined
                yield Result.new(:undefined, step)
              rescue Exception
                yield Result.new(:failed, step)
              end
            end
          end
        end
      end
    end
  end
end
