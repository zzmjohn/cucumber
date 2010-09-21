$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yaml'
begin
  require 'gherkin'
rescue LoadError
  require 'rubygems'
  require 'gherkin'
end
require 'cucumber/platform'
require 'cucumber/parser'
require 'cucumber/step_mother'
require 'cucumber/cli/main'
require 'cucumber/broadcaster'
require 'cucumber/api'
require 'cucumber/formatter'

module Cucumber
  class << self
    include Cucumber::Api
    attr_accessor :wants_to_quit
    
    def logger
      @log ||= Logger.new(STDOUT)
    end
    
    def logger=(logger)
      @log = logger
    end
  end
end