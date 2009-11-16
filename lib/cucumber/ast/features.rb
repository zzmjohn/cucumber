module Cucumber
  module Ast
    class Features #:nodoc:
      include Enumerable

      attr_reader :duration, :adverbs

      def initialize
        @features = []
        @adverbs = []
      end

      def [](index)
        @features[index]
      end

      def each(&proc)
        @features.each(&proc)
      end

      def add_feature(feature)
        feature.features = self
        @adverbs += feature.adverbs
        @adverbs.uniq!
        @features << feature
      end

      def accept(visitor)
        return if Cucumber.wants_to_quit
        start = Time.now
        self.each do |feature|
          visitor.visit_feature(feature)
        end
        @duration = Time.now - start
      end

      def tag_count(tag)
        @features.inject(0){|count, feature| count += feature.feature_and_children_tag_count(tag)}
      end

    end
  end
end
