module Cucumber
  # The base class for configuring settings for a Cucumber run.
  class Configuration
    def self.default
      new
    end
    
    def self.parse(argument)
      return new(argument) if argument.is_a?(Hash)
      argument
    end
    
    def initialize(options = {})
      @options = options
      @default = {
        :auto_load_paths => [ 
          'features/step_definitions', 
          'features/support' ] + 
          Dir['vendor/{gems,plugins}/*/cucumber']
      }
    end
    
    def build_tree_walker(runtime)
      Ast::TreeWalker.new(runtime, formatters, self)
    end
    
    def formatters
      @formatters ||= []
    end
    
    def auto_load_paths
      @options[:auto_load_paths] || @default[:auto_load_paths]
    end
    
    def excluded_paths
      []
    end
    
    def feature_files
      Dir['features/*.feature']
    end
    
    def filters
      []
    end
    
    def tag_expression
      Gherkin::TagExpression.new([])
    end
    
    def dry_run?
      @options[:dry_run]
    end
    
    def guess?
      @options[:guess]
    end
    
    def strict?
      @options[:strict]
    end
    
    def expand? 
      @options[:expand]
    end
    
    def paths
      @options[:paths]
    end
  end
end