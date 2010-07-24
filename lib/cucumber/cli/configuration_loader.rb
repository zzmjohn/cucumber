require 'cucumber/cli/args_parser'
require 'cucumber/constantize'

module Cucumber
  module Cli
    class ConfigurationLoader
      DEFAULT_PROFILE = 'default'
      
      def initialize(out_stream, error_stream)
        @out_stream = out_stream
        @error_stream = error_stream
        @args_parser = ArgsParser.new(@out_stream, @error_stream)
      end
      
      def load_from_args(args)
        config = @args_parser.parse!(args)

        if config.disable_profile_loading?
          @out_stream.puts "Disabling profiles..."
        else
          config = merge_profiles(config)
        end

        print_profile_information(config)
        
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
      
      def merge_profiles(config)
        config[:profiles] << DEFAULT_PROFILE if default_profile_should_be_used?(config)

        config[:profiles].each do |profile|
          profile_args = profile_loader.args_from(profile)
          profile_config = ArgsParser.parse(profile_args, @out_stream, @error_stream)
          config.reverse_merge(profile_config)
        end
        config
      end

      def default_profile_should_be_used?(config)
        profiles = config.profiles
        profiles.empty? &&
          profile_loader.cucumber_yml_defined? &&
          profile_loader.has_profile?(DEFAULT_PROFILE)
      end

      def profile_loader
        @profile_loader ||= ProfileLoader.new
      end
      
      def print_profile_information(config)
        return if config[:profiles].empty?
        profiles = config.profiles
        profiles_sentence = ''
        profiles_sentence = profiles.size == 1 ? profiles.first :
          "#{profiles[0...-1].join(', ')} and #{profiles.last}"

        @out_stream.puts "Using the #{profiles_sentence} profile#{'s' if profiles.size> 1}..."
      end
            
    end
  end
end
