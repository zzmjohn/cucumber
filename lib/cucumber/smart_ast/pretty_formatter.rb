module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(_,io,__)
        @io = io
      end
      
      def before_feature(feature)
        @io.puts feature.name
      end
      
      def before_scenario(scenario)
        @io.puts
        @io.puts "  " + scenario.name
      end
      
      def after_scenario(scenario)
        @io.puts
      end
    end
  end
end