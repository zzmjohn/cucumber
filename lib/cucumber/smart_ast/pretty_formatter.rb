module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(_,io,__)
        @io = io
      end
      
      def before_feature(feature)
        @io.puts heading(feature)
      end
      
      def before_scenario(scenario)
        @io.puts
        @io.puts "  " + heading(scenario)
      end
      
      def after_scenario(scenario)
        @io.puts
      end
      
      private
      
      def heading(element)
        "#{element.kw}: #{element.title}"
      end
    end
  end
end