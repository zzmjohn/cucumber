module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(io)
        @io = io
      end
      
      def before_feature(feature)
        @io.puts feature.name
      end
      
      def before_scenario(scenario)
        @io.puts
        @io.puts "  " + scenario.name
      end
    end
  end
end