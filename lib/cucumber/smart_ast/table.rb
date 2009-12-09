module Cucumber
  module SmartAst
    class Table
      include Enumerable
      
      attr_reader :raw, :line
      def initialize(rows, line)
        @raw, @line = rows, line
      end

      def headers
        @raw.first
      end
      
      def rows
        @raw[1..-1]
      end
      
      def hashes
        @hashes ||= rows.map do |row|
          to_hash(row)
        end
      end
      
      def to_hash(cells) #:nodoc:
        hash = Hash.new
        headers.each_with_index do |column_name, column_index|
          hash[column_name] = cells[column_index]
        end
        hash
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
