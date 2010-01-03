require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/node'

module Cucumber
  module SmartAst
    class Examples < Node
      include Tags
      include Description
      extend Forwardable
      
      attr_reader :scenario_outline, :table
      
      def initialize(keyword, description, line, tags, table, scenario_outline)
        super(keyword, description, line)
        @tags, @table, @scenario_outline = tags, table, scenario_outline
      end
      
      def_delegators :scenario_outline, 
        :language,
        :feature,
        :background_steps
    end
  end
end
