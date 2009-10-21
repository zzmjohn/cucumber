require 'cucumber/filter'

module Cucumber
  module Source
    class GherkinBuilder
      attr_reader :source, :lang
      
      def initialize(source, path, lines, lang)
        @source, @path, @lines, @lang = source, path, lines, lang
      end
      
      # Parses a file and returns a Cucumber::Ast
      # If +options+ contains tags, the result will
      # be filtered.
      def parse(feature_loader, options)
        filter = Filter.new(@lines, options)
        language = feature_loader.load_natural_language(lang || options[:lang] || 'en')
        language.parse(source, @path, filter)
      end
    end
  end
end