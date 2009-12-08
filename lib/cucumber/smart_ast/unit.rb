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
    end
  end
end
