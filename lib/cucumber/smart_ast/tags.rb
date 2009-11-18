require 'cucumber/smart_ast/tag'

module Cucumber
  module SmartAst
    module Tags
      attr_reader :tags
      def tag(tag, line)
        @tags ||= []
        tag = Tag.new(tag, line)
        @tags << tag
        tag
      end
    end
  end
end
