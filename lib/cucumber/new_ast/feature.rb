require 'cucumber/new_ast/background'
require 'cucumber/new_ast/scenario'
require 'cucumber/new_ast/scenario_outline'
require 'cucumber/asg/asg'

module Cucumber
  module NewAst
    class Feature
      attr_writer :language, :features
      
      def initialize(keyword, name, line)
        @elements = []
      end

      def background(keyword, name, line)
        @background = Background.new(keyword, name, line)
      end

      def scenario(keyword, name, line)
        s = Scenario.new(keyword, name, line)
        @elements << s
        s
      end

      def scenario_outline(keyword, name, line)
        s = ScenarioOutline.new(keyword, name, line)
        @elements << s
        s
      end

      def asg
        Asg::Asg.new(self)
      end
    end
  end
end