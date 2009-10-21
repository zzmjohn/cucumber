require 'cucumber/parser/natural_language'
require 'cucumber/feature_file'
require 'cucumber/formatter/duration'
require 'cucumber/source/file_input'
require 'cucumber/source/gherkin_builder'

module Cucumber
  class FeatureLoader
    attr_writer :options, :log
    attr_reader :adverbs
    include Formatter::Duration
    include Source
    
    def initialize
      load_natural_language('en')
    end
    
    def load_plain_text_features(feature_files)
      features = Ast::Features.new

      start = Time.new
      log.debug("Features:\n")
      feature_files.each do |f|
        FileInput.new(f)
        feature_file = GherkinBuilder.new(f.source, f.path, f.lines, f.lang)
        feature = feature_file.parse(self, options)
        if feature
          features.add_feature(feature)
          log.debug("  * #{f}\n")
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
