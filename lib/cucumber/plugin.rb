module Cucumber
  module Plugin
    def register_input(input_class)
      FeatureLoader.register_input(input_class)
    end
    
    def register_parser(parser_class)
      FeatureLoader.register_parser(parser_class)
    end
    
    def register_format_rule(re, format)
      FeatureLoader.register_format_rule(re, format)
    end
  end
end
