require 'cucumber/new_ast/scenario'

module Cucumber
  module NewAst
    class Feature
      attr_writer :language, :features
      
      def initialize(keyword, name, line)
        @elements = []
      end
      
      def scenario(keyword, name, line)
        s = Scenario.new(keyword, name, line)
        @elements << s
        s
      end

      def execute
        @elements.each do |element|
          element.execute
        end
      end
    end
  end
end