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
      
      def columns
        @raw.transpose
      end
              
      def each(&block)
        rows.each do |row|
          yield row
        end
      end
      
      def hashes
        @hashes ||= collect do |row|
          hash_of(row)
        end
      end
            
      private
      
      def hash_of(row)
        hash = Hash.new { |h, k| h[k.to_s] if k.is_a? Symbol }
        headers.zip(row).each do |k, v|
          hash[k] = v
        end
        hash
      end      
    end
  end
end
