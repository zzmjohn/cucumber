module Cucumber
  module Parser
    class NaturalLanguage
      KEYWORD_KEYS = %w{name native feature background scenario scenario_outline examples given when then and but}

      class << self
        def get(lang)
          languages[lang] ||= new(lang)
        end

        def languages
          @languages ||= {}
        end

        def parser=(treetop_or_gherkin)
          @parser = treetop_or_gherkin
        end

        def parser
          @parser ||= :treetop
        end
      end

      def initialize(lang)
        @lang = lang
        @keywords = Cucumber::LANGUAGES[lang]
        raise "Language not supported: #{lang.inspect}" if @keywords.nil?
        @keywords['grammar_name'] = @keywords['name'].gsub(/\s/, '')
        @parser = nil
      end
      
      def adverbs
        %w{given when then and but}.map{|keyword| @keywords[keyword].split('|').map{|w| w.gsub(/[\s<']/, '')}}.flatten
      end

      def parse(source, path, filter)
        feature = (self.class.parser == :treetop) ? treetop_parse(source, path, filter) : gherkin_parse(source, path, filter)
        feature.language = self if feature
        feature
      end

      def treetop_parse(source, path, filter)
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

      def gherkin_parse(source, path, filter)
        require 'cucumber/new_ast/builder'

        builder = NewAst::Builder.new
        new_gherkin_parser(builder).scan(source)
        builder.ast
      end

      def new_gherkin_parser(builder)
        require "gherkin/parser"
        Gherkin::Parser.new(@lang, builder, false)
      end

      def keywords(key, raw=false)
        return @keywords[key] if raw
        return nil unless @keywords[key]
        values = @keywords[key].to_s.split('|')
        if ['given', 'when', 'and', 'then', 'but'].include? key
          values.map{|value| %Q{"#{keyword_space(value)}"}}.join(" / ")
        else
          values.map{|value| %Q{"#{(value)}"}}.join(" / ")
        end 
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

      def step_keywords
        %w{given when then and but}.map{|key| @keywords[key].split('|').map{|kw| keyword_space(kw).delete("'")}}.flatten.uniq
      end

      private
 
      def keyword_space(val)
        (val + ' ').sub(/< $/,'')
      end
    end
  end
end
