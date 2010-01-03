require 'cucumber/smart_ast/listeners_broadcaster'
require 'cucumber/smart_ast/run'

module Cucumber
  module SmartAst
    class Features
      attr_accessor :adverbs
      
      def initialize
        @adverbs = []
        @units = []
      end
      
      def execute(step_mother, listeners)
        listeners.extend(ListenersBroadcaster)
        Run.new(listeners, step_mother).execute(@units)
      end
      
      def add_feature(units)
        units.each do |unit|
          @units << unit
        end
      end
    end
  end
end