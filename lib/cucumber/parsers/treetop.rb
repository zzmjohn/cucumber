require 'cucumber/plugin'
require 'cucumber/parser/natural_language'
require 'cucumber/filter'

module Cucumber
  module Parsers
    class Treetop
      extend Cucumber::Plugin
      register_parser(self)
      
      LANGUAGE_PATTERN = /language\s*:\s*(.*)/ #:nodoc:

      def format
        :treetop
      end
      
      # Parses a file and returns a Cucumber::Ast
      # If +options+ contains :tag_names or :name_regexps, the result will
      # be filtered.
      def parse(content, path, lines, options)
        filter = Filter.new(lines, options)
        language = load_natural_language(lang(content) || options[:lang] || 'en')
        language.parse(content, path, filter)
      end
      
      def lang(content)
        line_one = content.split(/\n/)[0]
        if line_one =~ LANGUAGE_PATTERN
          $1.strip
        else
          nil
        end
      end
      
      def load_natural_language(lang)
        Parser::NaturalLanguage.get(lang)
      end
    end
  end
end
