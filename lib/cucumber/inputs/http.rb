require 'open-uri'

module Cucumber
  module Inputs
    class HTTP
      def protocols
        [:http, :https]
      end

      def read(uri)
        open_and_read(uri)
      end

      def list(uri)
        open_and_read(uri).split
      end

      private

      def open_and_read(uri)
        open(uri).read
      end
    end
  end
end
