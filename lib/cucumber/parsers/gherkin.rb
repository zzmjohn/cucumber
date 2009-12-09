require 'cucumber/plugin'
require 'cucumber/filter'
require 'cucumber/smart_ast/builder'
require 'gherkin'
require 'gherkin/i18n'

module Cucumber
  module Parsers
    class Gherkin
      extend Cucumber::Plugin
      register_parser(self)
      register_format_rule(/\.feature$/, :gherkin)
      
      LANGUAGE_PATTERN = /language\s*:\s*(.*)/ #:nodoc:

      def format
        :gherkin
      end
      
      # Parses a file and returns a Cucumber::Ast
      # If +options+ contains :tag_names or :name_regexps, the result will
      # be filtered.
      def parse(content, path, lines, options)
        puts "Parsing #{path} with Gherkin"
        # Leave filtering for when the new ast is stable
        # filter = Filter.new(lines, options) 
        
        builder = SmartAst::Builder.new
        parser = ::Gherkin::Parser.new(builder, true, "root")
        
        # TODO: I18n Lexer should attach the proper instance of I18n to the Lexer it 
        # returns so we don't need to find it separately; the adverbs method should be 
        # added to the I18n class in Gherkin proper.
        language = ::Gherkin::I18n.get(lang(content) || 'en')
        def language.adverbs
          %w{given when then and but}.map{|keyword| @keywords[keyword].split('|').map{|w| w.gsub(/[\s<']/, '')}}.flatten
        end

        lexer = ::Gherkin::I18nLexer.new(parser)
        lexer.scan(content)
        
        # builder.language = lexer.language
        builder.language = language
        builder.ast        
      end
    
      def lang(content)
        line_one = content.split(/\n/)[0]
        if line_one =~ LANGUAGE_PATTERN
          $1.strip
        else
          nil
        end
      end      
    end
  end
end
