
require 'cucumber/cli/args_parser'
require 'cucumber/constantize'
require 'gherkin/parser/tag_expression'

module Cucumber
  module Cli
    class YmlLoadError < StandardError; end
    class ProfilesNotDefinedError < YmlLoadError; end
    class ProfileNotFound < StandardError; end

    class ConfigurationLoader
      def initialize(out_stream, error_stream)
        @out_stream = out_stream
        @error_stream = error_stream
        @args_parser = ArgsParser.new(@out_stream, @error_stream, :default_profile => 'default')
      end
      
      def load_from_args(args)
        @args = args
        @config = @args_parser.parse!(args)

        arrange_formats
        raise("You can't use both --strict and --wip") if @config.strict? && @config.wip?

        return @args.replace(@config.expanded_args_without_drb) if @config.drb?

        set_environment_variables
        
        @config
      end
      
      private
      
      def set_environment_variables
        @config[:env_vars].each do |var, value|
          ENV[var] = value
        end
      end
      
      def arrange_formats
        @config[:formats] << ['pretty', @out_stream] if @config[:formats].empty?
        @config[:formats] = @config[:formats].sort_by{|f| f[1] == @out_stream ? -1 : 1}
        streams = @config[:formats].map { |(_, stream)| stream }
        if streams != streams.uniq
          raise "All but one formatter must use --out, only one can print to each stream (or STDOUT)"
        end
      end
    end
  end
end
