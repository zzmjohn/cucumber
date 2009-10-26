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
      feature_suite = Ast::Features.new

      start = Time.new
      log.debug("Features:\n")
      sources.each do |source|
        feature = load_feature(source)
        if feature
          feature_suite.add_feature(feature)
          log.debug("  * #{source}\n")
        end
      end
      duration = Time.now - start
      log.debug("Parsing feature files took #{format_duration(duration)}\n\n")
      feature_suite
    end

    def load_feature(source)
      _, name, lines = *SOURCE_COLON_LINE_PATTERN.match(source)
      if name
        lines = lines.split(':').map { |line| line.to_i }
      else
        name = source
      end

      input = Inputs::File.new(name)
      builder = Builders::Gherkin.new(input.content, name, lines || nil)
      feature = builder.parse(options)

      # It would be nice if adverbs lived on Ast::Feature, 
      # then adding them to the feature suite could merge them.
      # And maybe StepMother could get them from there?
      self.adverbs = builder.adverbs if feature

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
