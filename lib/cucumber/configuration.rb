module Cucumber
  class Configuration

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

    add_setting :error_stream
    add_setting :output_stream
    add_setting :output, :alias => :output_stream

    add_setting :strict, :default => false
    add_setting :dry_run, :default => false
    add_setting :diff_enabled, :default => true 
    add_setting :tags
    add_setting :multiline
    add_setting :'no-source'
    add_setting :quiet
    add_setting :wip
    add_setting :guess
    add_setting :snippets, :default => true
    add_setting :colour, :default => true
    add_setting :color,  :alias => :colour
    add_setting :require, :default => []    
    add_setting :verbose
    add_setting :drb

    def settings
      @settings ||= default_options
    end
    
    def [](key)
      settings[key]
    end

    def []=(key, value)
      settings[key] = value
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
        :diff_enabled => true
      }
    end
    
    def merge_options!(options_args)
      options = Options.parse(options_args, @out_stream, @error_stream)
      reverse_merge(options)
    end

    require 'rubygems'
    require 'ruby-debug'
    
    def reverse_merge(other_options)
      debugger
      other_settings = (other_options.send(:options)).settings
      
      @settings = other_settings.merge(@settings)
      @settings[:require] += other_settings[:require]
      @settings[:excludes] += other_settings[:excludes]
      @settings[:name_regexps] += other_settings[:name_regexps]
      @settings[:tag_expressions] += other_settings[:tag_expressions]
      @settings[:env_vars] = other_settings[:env_vars].merge(@settings[:env_vars])
      if @settings[:paths].empty?
        @settings[:paths] = other_settings[:paths]
      else
#        @overridden_paths += (other_settings[:paths] - @settings[:paths])
      end
      @settings[:source] &= other_settings[:source]
      @settings[:snippets] &= other_settings[:snippets]
      @settings[:strict] |= other_settings[:strict]

#      @profiles += other_settings.profiles
#      @expanded_args += other_settings.expanded_args

      if @settings[:formats].empty?
        @settings[:formats] = other_settings[:formats]
      else
        @settings[:formats] += other_settings[:formats]
        @settings[:formats] = stdout_formats[0..0] + non_stdout_formats
      end

      self
    end
  end
  
  def self.configuration
    @configuration ||= Cucumber::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
