require 'cucumber/smart_ast/tag'

module Cucumber
  module SmartAst
    module Tags      
      def tags
        @tags ||= []
      end
    end
  end
end
