require 'cucumber/smart_ast/listeners_broadcaster'

module Cucumber
  module SmartAst
    class Features < Array
      attr_accessor :adverbs
      
      def initialize
        @adverbs = []
      end
      
      def execute(step_mother, listeners)
        listeners.extend(ListenersBroadcaster)
        
        units.each do |unit|
          unit.execute(step_mother, listeners)
        end
      end
      
      def add_feature(feature)
        self.<<(feature)
      end
      
      private
      
      def units
        map{ |feature| feature.units }.flatten
      end
      
    end
  end
end