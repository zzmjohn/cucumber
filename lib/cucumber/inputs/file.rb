module Cucumber
  module Inputs
    class File
      def protocols
        [:file]
      end

      def read(uri)
        ::File.open(uri, Cucumber.file_mode('r')).read
      rescue Errno::EACCES => e
        p = ::File.expand_path(uri)
        e.message << "\nCouldn't open #{p}"
        raise e
      end

      # Leave this in for historical purposes until we have an HTTP loader
      def content
        @source ||= if @path =~ /^http/
          require 'open-uri'
          open(@path).read
        else
          begin
            ::File.open(@path, Cucumber.file_mode('r')).read 
          rescue Errno::EACCES => e
            p = File.expand_path(@path)
            e.message << "\nCouldn't open #{p}"
            raise e
          end
        end
      end
    end
  end
end
