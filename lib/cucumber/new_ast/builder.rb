require 'cucumber/new_ast/feature'

module Cucumber
  module NewAst
    # Implements the Gherkin listener API and builds an AST from Gherkin's scanner.
    class Builder
      def ast
        @feature
      end
      
      def comment(text, line)
      end

      def tag(name, line)
      end

      def feature(keyword, name, line)
        @feature = Feature.new(keyword, name, line)
      end

      def background(keyword, name, line)
        @step_container = @feature.background(keyword, name, line)
      end

      def scenario(keyword, name, line)
        @step_container = @feature.scenario(keyword, name, line)
      end

      def scenario_outline(keyword, name, line)
        @step_container = @feature.scenario_outline(keyword, name, line)
      end

      def examples(keyword, name, line)
        @table_container = @step_container.examples(keyword, name, line)
      end

      def table(raw, line)
        @table_container.table(raw, line)
      end

      def py_string(string, line, col)
        @table_container.py_string(string, line, col)
      end

      def step(keyword, name, line)
        @table_container = @step_container.step(keyword, name, line)
      end

      def syntax_error(*args)
        STDERR.puts "SYNTAX ERROR"
        STDERR.puts args.inspect
      end
    end
  end
end
