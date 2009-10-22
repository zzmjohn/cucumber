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
      @adverbs = ["Given", "When", "Then", "And", "But"] # haxx?
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
        feature_file = Builders::Gherkin.new(input.content, input.path, lines || nil)
        feature = feature_file.parse(options)
        if feature
          features.add_feature(feature)        # It would be nice if adverbs lived on Ast::Feature, 
          self.adverbs = feature_file.adverbs  # then adding them to the feature suite could merge them.
          log.debug("  * #{source}\n")         # And maybe StepMother could get them from there?
        end
      end
      duration = Time.now - start
      log.debug("Parsing feature files took #{format_duration(duration)}\n\n")
      features
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
