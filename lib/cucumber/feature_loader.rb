require 'cucumber/formatter/duration'
require 'uri'

module Cucumber
  class InputServiceNotFound < IndexError
    def initialize(proto, available)
      super "No input service for the '#{proto}' protocol has been registered. Services available: #{available.join(', ')}."
    end
  end
  
  class AmbiguousFormatRules < StandardError
    def initialize(name, matches)
      matches = matches.collect { |rule| rule[0].inspect }.join(', ')
      super "'#{name}' is matched by multiple format rules: #{matches}"
    end
  end
  
  class FeatureLoader
    class << self
      def register_input(input_class)
        @@input_plugins ||= []
        @@input_plugins << input_class
      end
      
      def register_parser(parser_class)
        @@parser_plugins ||= []
        @@parser_plugins << parser_class
      end      
    end

    SOURCE_COLON_LINE_PATTERN = /^([\w\W]*?):([\d:]+)$/ #:nodoc:
    
    attr_writer :options, :log
    attr_reader :format_rules
    include Formatter::Duration
    
    def initialize
      @format_rules = {}
    end

    def instantiate_plugins!
      @@input_plugins.each do |input_class|
        register_input(input_class.new)
      end
      
      @@parser_plugins.each do |parser_class|
        register_parser(parser_class.new)
      end
    end
    
    def register_input(input)
      @inputs ||= {}
      input.protocols.each { |proto| @inputs[proto] = input }
    end
        
    def register_parser(parser)
      @parsers ||= {}
      @parsers[parser.format] = parser
      
      if parser.respond_to?(:format_rules)
        parser.format_rules.each_pair do |rule, format| 
          register_format_rule(rule, format)
        end
      end
    end
    
    def register_format_rule(rule, format)
      @format_rules ||= {}
      @format_rules[rule] = format
    end
    
    def protocols
      @inputs.keys
    end
    
    def formats
      @parsers.keys
    end
        
    def load_features(uris)
      feature_suite = Ast::Features.new

      lists, uris = uris.partition { |uri| uri =~ /^@/ }
      lists.map! { |list| list.gsub(/^@/, '') }
      lists.inject(uris) { |uris, list| uris += input(list).list(list) }

      start = Time.new
      log.debug("Features:\n")
      uris.each do |uri|
        feature = load_feature(uri)
        if feature
          feature_suite.add_feature(feature)
          log.debug("  * #{uri}\n")
        end
      end
      duration = Time.now - start
      log.debug("Parsing feature files took #{format_duration(duration)}\n\n")
      feature_suite
    end

    def load_feature(uri)
      _, name, lines = *SOURCE_COLON_LINE_PATTERN.match(uri)
      if name
        lines = lines.split(':').map { |line| line.to_i }
      else
        name = uri
      end

      content = input(name).read(name)                 
      parser(name).parse(content, name, lines || nil, options)
    end

    def input(name)
      uri = URI.parse(URI.escape(name))
      proto = (uri.scheme || :file).to_sym
      @inputs[proto] || raise(InputServiceNotFound.new(proto, protocols))
    end
    
    def parser(name)      
      matches = @format_rules.select { |rule, _| rule.match(name) }
      if matches.empty?
        format = name.split('.').last.to_sym
        @parsers[format] || @parsers[:treetop] # Change back to :gherkin when Gherkin replaces Treetop
      elsif matches.length > 1
        raise AmbiguousFormatRules.new(name, matches)
      else
        @parsers[matches[0].last]
      end
    end
    
    def log
      @log ||= Logger.new(STDOUT)
    end
        
    def options
      @options ||= {}
    end
  end
end
