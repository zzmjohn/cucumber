require 'cucumber/formatter/duration'
require 'cucumber/inputs/file'
require 'cucumber/parsers/gherkin'
require 'uri'

module Cucumber
  class InputServiceNotFound < IndexError
    def initialize(proto, available)
      super "No input service for the '#{proto}' protocol has been registered. Services available: #{available.join(' ')}."
    end
  end
  
  class FeatureLoader
    SOURCE_COLON_LINE_PATTERN = /^([\w\W]*?):([\d:]+)$/ #:nodoc:
    
    attr_writer :options, :log
    attr_reader :adverbs
    include Formatter::Duration
    
    def initialize
      @adverbs = ["Given", "When", "Then", "And", "But"] # haxx?
      @parser = Parsers::Gherkin.new
      register_input(Inputs::File.new)
    end

    def register_input(input)
      @inputs ||= {}
      input.protocols.each { |proto| @inputs[proto] = input }
    end

    def register_parser(parser)
      @parser = parser
    end
    
    def protocols
      @inputs.keys
    end
    
    def load_features(uris)
      feature_suite = Ast::Features.new

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

      uri = URI.parse(URI.escape(name))
      proto = (uri.scheme || :file).to_sym
      
      begin
        content = @inputs.fetch(proto).read(name)
      rescue IndexError
        raise InputServiceNotFound.new(proto, protocols)
      end
      
      feature = @parser.parse(content, name, lines || nil, options)

      # It would be nice if adverbs lived on Ast::Feature, 
      # then adding them to the feature suite could merge them.
      # And maybe StepMother could get them from there?
      self.adverbs = @parser.adverbs if feature

      feature
    end

    # The only reason FeatureLoader has these is so StepMother can learn about them...
    def adverbs=(adverbs)
      @adverbs += adverbs
      @adverbs.uniq!
    end
              
    def log
      @log ||= Logger.new(STDOUT)
    end
        
    def options
      @options ||= {}
    end
  end
end
