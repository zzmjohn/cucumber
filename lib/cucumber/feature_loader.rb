require 'cucumber/parser/natural_language'
require 'cucumber/feature_file'
require 'cucumber/formatter/duration'
require 'cucumber/inputs/file'
require 'cucumber/builders/gherkin'

module Cucumber
  class FeatureLoader
    SOURCE_COLON_LINE_PATTERN = /^([\w\W]*?):([\d:]+)$/ #:nodoc:
    
    attr_writer :options, :log
    attr_reader :adverbs
    include Formatter::Duration
    
    def initialize
      load_natural_language('en')
    end
    
    def load_features(sources)
      features = Ast::Features.new

      start = Time.new
      log.debug("Features:\n")
      sources.each do |source|
        _, name, lines = *SOURCE_COLON_LINE_PATTERN.match(source)
        if name
          lines = lines.split(':').map { |line| line.to_i }
        else
          name = source
        end
        
        input = Inputs::File.new(name)
        feature_file = Builders::Gherkin.new(input.content, input.path, lines || nil, input.lang)
        feature = feature_file.parse(self, options)
        if feature
          features.add_feature(feature)
          log.debug("  * #{source}\n")
        end
      end
      duration = Time.now - start
      log.debug("Parsing feature files took #{format_duration(duration)}\n\n")
      features
    end
    
    # Loads a natural language and registers its adverbs with the FeatureLoader
    #
    def load_natural_language(lang)
      parser = Parser::NaturalLanguage.get(lang)
      self.adverbs = parser.adverbs
      parser
    end

    def adverbs=(adverbs)
      @adverbs ||= []
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
