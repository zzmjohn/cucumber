module Cucumber
  class FileFinder
    def initialize(configuration)
      @configuration = configuration
      @files = if configuration.respond_to?(:auto_load_paths)
        scan(configuration.auto_load_paths)
      else
        legacy_scan
      end
    end
    
    def step_definition_files
      @files
    end
  private
  
    def scan(paths)
      step_defs_to_load + support_to_load
    end
    
    def all_files_to_load
      requires = @configuration.auto_load_paths
      files = requires.map do |path|
        path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
        path = path.gsub(/\/$/, '') # Strip trailing slash.
        File.directory?(path) ? Dir["#{path}/**/*"] : path
      end.flatten.uniq
      remove_excluded_files_from(files)
      files.reject! {|f| !File.file?(f)}
      files.reject! {|f| File.extname(f) == '.feature' }
      files.reject! {|f| f =~ /^http/}
      files.sort
    end

    def step_defs_to_load
      all_files_to_load.reject {|f| f =~ %r{/support/} }
    end

    def support_to_load
      support_files = all_files_to_load.select {|f| f =~ %r{/support/} }
      env_files = support_files.select {|f| f =~ %r{/support/env\..*} }
      other_files = support_files - env_files
      @configuration.dry_run? ? other_files : env_files + other_files
    end
    
    def remove_excluded_files_from(files)
      files.reject! {|path| @configuration.excluded_paths.detect {|pattern| path =~ pattern } }
    end
    
    def legacy_scan
      @configuration.support_to_load + @configuration.step_defs_to_load
    end
  
  end
end