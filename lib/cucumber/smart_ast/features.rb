require 'cucumber/smart_ast/listeners_broadcaster'
require 'cucumber/smart_ast/run'

module Cucumber
  module SmartAst
    class Features < Array
      attr_accessor :adverbs
      
      def initialize
        @adverbs = []
        @units = []
      end
      
      def execute(step_mother, listeners)
        listeners.extend(ListenersBroadcaster)
        run = Run.new(listeners, step_mother)
        
        @units.each do |unit|
          unit.execute(run)
        end
      end
      
      def add_feature(units)
        units.each do |unit|
          @units << unit
        end
      end
    end
  end
end