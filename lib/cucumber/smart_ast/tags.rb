require 'cucumber/smart_ast/tag'

module Cucumber
  module SmartAst
    module Tags
      
      # HACK: needed because the executor just blindly broadcasts tags w/o
      # checking to see if they exist. Would return nil otherwise. A better
      # iterator on the feature might take care of this, so we can do: 
      #
      # if feature.tags
      #   broacast_tags(tags)
      #   tags.each { |tag| broadcast_tag_name(tag.name) }
      # end
      def tags
        @tags || []
      end
      
      def tag(tag, line)
        @tags ||= []
        tag = Tag.new(tag, line)
        @tags << tag
        tag
      end
    end
  end
end
