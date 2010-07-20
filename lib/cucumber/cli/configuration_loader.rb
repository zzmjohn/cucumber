
require 'cucumber/cli/args_parser'
require 'cucumber/constantize'
require 'gherkin/parser/tag_expression'

module Cucumber
  module Cli
    class ConfigurationLoader
      def initialize(out_stream, error_stream)
        @out_stream = out_stream
        @error_stream = error_stream
        @args_parser = ArgsParser.new(@out_stream, @error_stream, :default_profile => 'default')
      end
      
      def load_from_args(args)
        config = @args_parser.parse!(args)
        config = arrange_formats(config)
        raise("You can't use both --strict and --wip") if config.strict? && config.wip?
        #TODO: Why?
        #@args.replace(@config.expanded_args_without_drb) if @config.drb?
        set_environment_variables(config)
        config
      end
      
      private
      
      def set_environment_variables(config)
        config[:env_vars].each do |var, value|
          ENV[var] = value
        end
      end
      
      def arrange_formats(config)
        config[:formats] << ['pretty', @out_stream] if config[:formats].empty?
        config[:formats] = config[:formats].sort_by{|f| f[1] == @out_stream ? -1 : 1}
        streams = config[:formats].map { |(_, stream)| stream }
        if streams != streams.uniq
          raise "All but one formatter must use --out, only one can print to each stream (or STDOUT)"
        end
        config
      end
    end
  end
end
