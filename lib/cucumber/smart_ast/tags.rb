require 'cucumber/smart_ast/tag'

module Cucumber
  module SmartAst
    module Tags      
      def tags
        @tags ||= []
      end
      
      def tag(tag, line)
        tag = Tag.new(tag, line)
        tags << tag
        tag
      end
    end
  end
end
