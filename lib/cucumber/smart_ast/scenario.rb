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
    end
  end
end
