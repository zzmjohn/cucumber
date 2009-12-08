require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Unit 
      class << self
        def from_scenario(scenario)
          unit = new(scenario.steps)
          unit.language = scenario.language
          unit
        end
      end

      attr_reader :steps
      attr_accessor :language

      def initialize(steps)
        @steps = steps
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
