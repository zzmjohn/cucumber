module Cucumber
  module Plugin
    def register_input(input_class)
      FeatureLoader.registry[:inputs] << input_class
    end
    
    def register_parser(parser_class)
      FeatureLoader.registry[:parsers] << parser_class
    end
    
    def register_format_rule(rule, format)
      FeatureLoader.registry[:format_rules].store(rule, format)
    end
  end
end
