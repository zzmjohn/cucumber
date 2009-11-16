require 'cucumber/plugin'

module Cucumber
  module Inputs
    class File
      extend Cucumber::Plugin
      register_input(self)

      def protocols
        [:file]
      end

      def read(uri)
        open_and_read(uri)
      end

      def list(uri)
        open_and_read(uri).split
      end

      private

      def open_and_read(uri)
        ::File.open(uri, Cucumber.file_mode('r')).read
      rescue Errno::EACCES => e
        p = ::File.expand_path(uri)
        e.message << "\nCouldn't open #{p}"
        raise e
      end
    end
  end
end
