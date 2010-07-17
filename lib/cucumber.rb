$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yaml'
require 'cucumber/platform'
require 'cucumber/parser'
require 'cucumber/step_mother'
require 'cucumber/cli/main'
require 'cucumber/configuration'
require 'cucumber/broadcaster'

module Cucumber
  class << self
    attr_accessor :wants_to_quit

    def self.configuration
      @configuration ||= Cucumber::Core::Configuration.new
    end

    def self.configure
      yield configuration if block_given?
    end

    # def configure
    #   @configuration ||= Configuration.new
    #   new_options = Cucumber::RbSupport::Options.new
    #   yield new_options
    #   @configuration.merge(new_options.list)
    # end
  end
end
