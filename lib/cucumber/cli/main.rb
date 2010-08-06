begin
  require 'gherkin'
rescue LoadError
  require 'rubygems'
  require 'gherkin'
end
require 'cucumber'
require 'logger'
require 'cucumber/parser'
require 'cucumber/feature_file'
require 'cucumber/formatter/color_io'
require 'cucumber/cli/configuration_loader'
require 'cucumber/cli/drb_client'

module Cucumber
  module Cli
    class Main
      class << self
        def step_mother
          @step_mother ||= StepMother.new
        end

        def execute(args)
          new(args).execute!(step_mother)
        end
      end

      def initialize(args, out_stream = STDOUT, error_stream = STDERR)
        @args         = args
        if Cucumber::WINDOWS_MRI
          @out_stream   = out_stream == STDOUT ? Formatter::ColorIO.new(Kernel, STDOUT) : out_stream
        else
          @out_stream   = out_stream
        end

        @error_stream = error_stream
        @configuration = nil
      end

      def execute!(step_mother)
        trap_interrupt
        if configuration.drb?
          begin
            return DRbClient.run(@args, @error_stream, @out_stream, configuration.drb_port)
          rescue DRbClientError => e
            @error_stream.puts "WARNING: #{e.message} Running features locally:"
          end
        end

        step_mother.configuration = configuration
        step_mother.log = configuration.log

        if step_mother.dot_cucumber_present?
          step_mother.load_dot_cucumber_files
        else
          unless(ENV['CUCUMBER_SELF_TEST'])
            @error_stream.puts <<-EOM
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)

                       (::)   W A R N I N G   (::)

You don't have a .cucumber.rb file. This file is used to configure
Cucumber and will be mandatory after release 0.9.x. To make this
warning go away, just create a .cucumber.rb file in the root of your
project with the following contents: 

#{IO.read(File.dirname(__FILE__) + '/default_dot_cucumber.rb')}

(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
EOM
          end
          step_mother.load_code_files(configuration.support_to_load)
          step_mother.load_code_files(configuration.step_defs_to_load)
        end

        features = step_mother.load_plain_text_features(configuration.feature_files)

        runner = build_runner(step_mother, @out_stream)
        step_mother.visitor = runner # Needed to support World#announce

        configuration.validate_and_lock!

        runner.visit_features(features)

        failure = if configuration.wip?
          step_mother.scenarios(:passed).any?
        else
          step_mother.scenarios(:failed).any? ||
          (configuration.strict? && (step_mother.steps(:undefined).any? || step_mother.steps(:pending).any?))
        end
      rescue ProfilesNotDefinedError, YmlLoadError, ProfileNotFound => e
        @error_stream.puts e.message
        true
      end

      def configuration
        return Cucumber.configuration if @configuration_loaded

        configuration_loader = ConfigurationLoader.new(@out_stream, @error_stream)
        configuration = configuration_loader.load_from_args(@args)
        Cucumber.configuration = configuration
        @configuration_loaded = true
        Cucumber.configuration
      end

      private

      def build_runner(step_mother, io)
        Ast::TreeWalker.new(step_mother, configuration.formatters(step_mother), configuration, io)
      end

      def trap_interrupt
        trap('INT') do
          exit!(1) if Cucumber.wants_to_quit
          Cucumber.wants_to_quit = true
          STDERR.puts "\nExiting... Interrupt again to exit immediately."
        end
      end
    end
  end
end
