module Cucumber
  module Asg
    # A Unit is an executable sequence of statements. Statements can
    # be hooks, background steps, scenario steps or expanded scenario outline steps
    # from table rows
    class Unit
      def initialize(statements)
        @statements = statements
        puts "======"
        puts @statements.map{|s| s.name}
      end
    end
  end
end