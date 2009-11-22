module Cucumber
  module SmartAst
    class Executor
      attr_accessor :options #:nodoc:
      attr_reader   :step_mother #:nodoc:

      def initialize(step_mother, listeners = [], options = {}, io = STDOUT)
        @step_mother, @listeners, @options, @io = step_mother, listeners, options, io
      end
      
      def execute(ast)
        broadcast_feature(ast)
        background = ast.background
        
        if background
          broadcast_background(background)
          background.steps.each do |step| 
            broadcast_step_name(step.adverb, @step_mother.step_match(step.name), :undefined, 0, background)
          end
        end
        
        ast.scenarios.each do |scenario|
          broadcast_feature_element(scenario)
          broadcast_scenario_name(scenario.kw, scenario.description, "placeholder:-1", 0)
          @step_mother.before_and_after(scenario) do 
            if background
              background.steps.each { |step| invoke(step) }
            end
            scenario.steps.each do |step| 
              invoke(step)
              broadcast_step_name(step.adverb, @step_mother.step_match(step.name), :passed, 0, scenario)
            end
          end
        end
        
        ast.scenario_outlines.each do |scenario_outline|
          scenario_outline.each do |examples|
            examples.scenarios.each do |scenario|
              @step_mother.before_and_after(scenario) do
                if background
                  background.steps.each { |step| invoke(step) }
                end
                scenario.steps.each { |step| invoke(step) }
              end
            end
          end
        end
      end
      
      def invoke(step)
        # puts "Invoking #{step.to_s}"
        if step.argument
          @step_mother.invoke(step.name, step.argument.to_s)
        else
          @step_mother.invoke(step.name)
        end
      end
      
      #
      # Copied from ast/tree_walker.rb and modifed
      #
      
      def broadcast_features(features)
        broadcast(features)
      end

      def broadcast_feature(feature)
        broadcast(feature)
        broadcast_feature_name(feature.name)
        broadcast_tags(feature.tags) if feature.tags
      end

      def broadcast_feature_name(name)
        broadcast(name)
      end

      def broadcast_tags(tags)
        broadcast(tags)
        tags.each { |tag| broadcast_tag_name(tag.tag) }
      end

      def broadcast_tag_name(tag_name)
        broadcast(tag_name)
      end

      def broadcast_background(background)
        broadcast(background) do 
          broadcast_background_name(background.name, background.description, "foo.feature:-1", 0)
        end
      end

      def broadcast_background_name(keyword, name, file_colon_line, source_indent)
        broadcast(keyword, name, file_colon_line, source_indent)
      end

      # +feature_element+ is either Scenario or ScenarioOutline
      def broadcast_feature_element(feature_element)
        broadcast(feature_element) {} # HACK (trigger before and after)
      end

      def broadcast_examples_array(examples_array)
        broadcast(examples_array) do
          examples_array.accept(self)
        end
      end

      def broadcast_examples(examples)
        broadcast(examples) do
          examples.accept(self)
        end
      end

      def broadcast_examples_name(keyword, name)
        unless keyword =~ /:$/
          message = <<EOS


(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)

                    DEPRECATION WARNING

Future versions of Cucumber will not recognize #{keyword} 
unless it is followed by a colon. Make this change in
your features now to prevent this warning from appearing.

(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)(::)
EOS
          announce(message)
        end
        broadcast(keyword, name)
      end

      def broadcast_outline_table(outline_table)
        broadcast(outline_table) do
          outline_table.accept(self)
        end
      end

      def broadcast_scenario_name(keyword, name, file_colon_line, source_indent)
        broadcast(keyword, name, file_colon_line, source_indent)
      end

      def broadcast_steps(steps)
        broadcast(steps) do
          steps.accept(self)
        end
      end

      def broadcast_step(step)
        broadcast(step) do
          step.accept(self)
        end
      end

      def broadcast_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
        broadcast(keyword, step_match, multiline_arg, status, exception, source_indent, background) do
          broadcast_step_name(keyword, step_match, status, source_indent, background)
          broadcast_multiline_arg(multiline_arg) if multiline_arg
          broadcast_exception(exception, status) if exception
        end
      end

      def broadcast_step_name(keyword, step_match, status, source_indent, background) #:nodoc:
        broadcast(keyword, step_match, status, source_indent, background)
      end

      def broadcast_multiline_arg(multiline_arg) #:nodoc:
        broadcast(multiline_arg) do
          multiline_arg.accept(self)
        end
      end

      def broadcast_exception(exception, status) #:nodoc:
        broadcast(exception, status)
      end

      def broadcast_py_string(string)
        broadcast(string)
      end

      def broadcast_table_row(table_row)
        broadcast(table_row) do
          table_row.accept(self)
        end
      end

      def broadcast_table_cell(table_cell)
        broadcast(table_cell) do
          table_cell.accept(self)
        end
      end

      def broadcast_table_cell_value(value, status)
        broadcast(value, status)
      end

      # Comments aren't handled by the SmartAst yet
      # 
      # def broadcast_comment(comment)
      #   broadcast(comment) do
      #     comment.accept(self)
      #   end
      # end
      # 
      # def broadcast_comment_line(comment_line)
      #   broadcast(comment_line)
      # end

      # Print +announcement+. This method can be called from within StepDefinitions.
      def announce(announcement)
        broadcast(announcement)
      end

      # Embed +file+ of +mime_type+ in the formatter. This method can be called from within StepDefinitions.
      # For most formatters this is a no-op.
      def embed(file, mime_type)
        broadcast(file, mime_type)
      end

      private

      def broadcast(*args, &block)
        message = extract_method_name_from(caller)
        message.gsub!('broadcast_', '')
        
        # puts "Broadcasting #{message}!"
        
        if block_given?
          send_to_all("before_#{message}", *args)
          yield if block_given?
          send_to_all("after_#{message}", *args)
        else
          send_to_all(message, *args)
        end
      end

      def send_to_all(message, *args)
        @listeners.each do |listener|
          if listener.respond_to?(message)
            listener.__send__(message, *args)
          end
        end
      end

      def extract_method_name_from(call_stack)
        call_stack[0].match(/in `(.*)'/).captures[0]
      end      
    end
  end
end
