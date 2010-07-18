module Cucumber
  class Configuration
    
    def initialize
      @overridden_paths = []
      @expanded_args = []
    end

    def self.add_setting(name, opts={})
      if opts[:alias]
        alias_method name, opts[:alias]
        alias_method "#{name}=", "#{opts[:alias]}="
        alias_method "#{name}?", "#{opts[:alias]}?"
      else
        define_method("#{name}=") {|val| settings[name] = val}
        define_method(name)       { settings.has_key?(name) ? settings[name] : opts[:default] }
        define_method("#{name}?") { !!(send name) }
      end
    end

    add_setting :strict, :default => false
    add_setting :tag_expressions
    add_setting :tags, :alias => :tag_expressions
    add_setting :wip
    add_setting :verbose
    add_setting :drb
    add_setting :profiles, :default => []


    def settings
      @settings ||= default_options
    end
    
    def [](key)
      settings[key]
    end

    def []=(key, value)
      settings[key] = value
    end
    
    def tag_expression
      Gherkin::Parser::TagExpression.new(@settings[:tag_expressions])
    end
    
    def custom_profiles
      profiles - ['default']
    end
    
    def non_stdout_formats
      @settings[:formats].select {|format, output| output != STDOUT }
    end

    def stdout_formats
      @settings[:formats].select {|format, output| output == STDOUT }
    end
    
    def expanded_args_without_drb
      @expanded_args_without_drb
    end

    def default_options
      {
        :strict       => false,
        :require      => [],
        :dry_run      => false,
        :formats      => [],
        :excludes     => [],
        :tag_expressions  => [],
        :name_regexps => [],
        :env_vars     => {},
        :diff_enabled => true,
        :profiles => []
      }
    end

    def merge_options!(options_args)
      options = OptionsParser.parse(options_args, @out_stream, @error_stream)
      reverse_merge(options)
    end

    def reverse_merge(other_options)
      @settings ||= default_options
      
      other_settings = other_options.settings
      @settings = other_settings.merge(@settings)
      @settings[:require] += other_settings[:require]
      @settings[:excludes] += other_settings[:excludes]
      @settings[:name_regexps] += other_settings[:name_regexps]
      @settings[:tag_expressions] += other_settings[:tag_expressions]
      @settings[:env_vars] = other_settings[:env_vars].merge(@settings[:env_vars])
      
      if @settings[:paths].empty?
        @settings[:paths] = other_settings[:paths]
      else

      @overridden_paths += (other_settings[:paths] - @settings[:paths])

      end
      @settings[:source] &= other_settings[:source]
      @settings[:snippets] &= other_settings[:snippets]
      @settings[:strict] |= other_settings[:strict]

      # @settings[:profiles] += other_settings[:profiles]

      @expanded_args += other_settings[:expanded_args]

      if @settings[:formats].empty?
        @settings[:formats] = other_settings[:formats]
      else
        @settings[:formats] += other_settings[:formats]
        @settings[:formats] = stdout_formats[0..0] + non_stdout_formats
      end
    end
    
    def filters
      @settings.values_at(:name_regexps, :tag_expressions).select{|v| !v.empty?}.first || []
    end
    
  end
  
  def self.configuration
    @configuration ||= Cucumber::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
