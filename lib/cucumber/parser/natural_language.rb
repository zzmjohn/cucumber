module Cucumber
  module Parser
    class NaturalLanguage
      KEYWORD_KEYS = %w{name native encoding space_after_keyword feature background scenario scenario_outline examples given when then and but}

      class << self
        def get(step_mother, lang)
          languages[lang] ||= new(step_mother, lang)
        end

        def languages
          @languages ||= {}
        end
      end

      def initialize(step_mother, lang)
        @lang = lang
        @keywords = Cucumber::LANGUAGES[lang]
        raise "Language not supported: #{lang.inspect}" if @keywords.nil?
        @keywords['grammar_name'] = @keywords['name'].gsub(/\s/, '')
        register_adverbs(step_mother) if step_mother
      end

      def register_adverbs(step_mother)
        adverbs = %w{given when then and but}.map{|keyword| @keywords[keyword].split('|').map{|w| w.gsub(/\s/, '')}}.flatten
        step_mother.register_adverbs(adverbs) if step_mother
      end

      def parse(source, path, filter, options)
        feature = if options[:parser] == :gherkin
          gherkin_parse(source, path, filter, options)
        else
          treetop_parse(source, path, filter, options)
        end
        feature.language = self if feature
        feature
      end

      def treetop_parse(source, path, filter, options)
        parser.parse_or_fail(source, path, filter)
      end

      # Treetop parser
      def parser
        return @parser if @treetop_parser
        i18n_tt = File.expand_path(File.dirname(__FILE__) + '/i18n.tt')
        template = File.open(i18n_tt, Cucumber.file_mode('r')).read
        erb = ERB.new(template)
        grammar = erb.result(binding)
        Treetop.load_from_string(grammar)
        @parser = Parser::I18n.const_get("#{@keywords['grammar_name']}Parser").new
        def @parser.inspect
          "#<#{self.class.name}>"
        end
        @parser
      end

      def gherkin_parse(source, path, filter, options)
        require 'gherkin/syntax_policy/feature_policy'
        require 'cucumber/new_ast/builder'

        builder = NewAst::Builder.new
        policy = Gherkin::SyntaxPolicy::FeaturePolicy.new(builder)
        gherkin_parser.new(policy).scan(source)
        builder.ast
      end

      def gherkin_parser
        require "gherkin/parser"
        require "gherkin/parser/parser_#{@lang}"
        Gherkin::Parser[@lang]
      end

      def keywords(key, raw=false)
        return @keywords[key] if raw
        return nil unless @keywords[key]
        values = @keywords[key].to_s.split('|')
        values.map{|value| "'#{value}'"}.join(" / ")
      end

      def incomplete?
        KEYWORD_KEYS.detect{|key| @keywords[key].nil?}
      end

      def scenario_keyword
        @keywords['scenario'].split('|')[0] + ':'
      end

      def but_keywords
        @keywords['but'].split('|')
      end

      def and_keywords
        @keywords['and'].split('|')
      end
    end
  end
end
