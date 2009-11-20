module Cucumber
  module SmartAst
    class Table
      include Enumerable
      
      attr_reader :raw
      def initialize(rows, line)
        @raw, @line = rows, line
      end

      def headers
        @raw.first
      end
      
      def rows
        @raw[1..-1]
      end
      
      def each(&block)
        rows.each do |row|
          yield hash_of(headers, row)
        end
      end
      
      private
      
      def hash_of(headers, row)
        Hash[*headers.zip(row).flatten]
      end
    end
  end
end
