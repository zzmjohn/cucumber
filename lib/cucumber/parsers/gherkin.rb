require 'gherkin'
require 'cucumber/filter'

module Cucumber
  module Parsers
    class Gherkin
      LANGUAGE_PATTERN = /language\s*:\s*(.*)/ #:nodoc:

      def format
        :gherkin
      end
      
      # Parses a file and returns a Cucumber::Ast
      # If +options+ contains :tag_names or :name_regexps, the result will
      # be filtered.
      def parse(content, path, lines, options)
        puts "Using Gherkin parser"
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
      
      def gherkin_parse(source, path, filter)
        require 'cucumber/smart_ast/builder'

        builder = SmartAst::Builder.new
        new_gherkin_parser(builder).scan(source)
        builder.ast
      end

      def new_gherkin_parser(builder)
        Gherkin::Lexer[@lang].new(builder)
      end
    end
  end
end
