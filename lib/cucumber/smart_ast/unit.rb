require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Unit < Scenario
      def accept_hook?(hook)
        false
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
           
      def language
        @feature.language
      end
    end
  end
end