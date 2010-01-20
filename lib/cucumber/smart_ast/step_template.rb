require 'cucumber/smart_ast/result_cell'

module Cucumber
  module SmartAst
    # Children of ScenarioOutline.
    class StepTemplate
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end

      def execute(header, row, step_mother, listener)
        name = @name.dup
        argument = @argument.dup if @argument

        n = -1
        result_cells = header.map{|key| ResultCell.new(key, row[n+=1])}

        result_cells.each do |result_cell|
          result_cell.attach(name, argument, self)
        end
        listener.before_step(self)
        e, status = step_mother.invoke2(name, argument)
      end

      def add_cell(cell)
        @cells ||= []
        @cells << cell
      end

      def report_to(gherkin_listener)
        gherkin_listener.step(@keyword, @name, @line)
        @argument.report_to(gherkin_listener) if @argument
      end
    end
  end
end
