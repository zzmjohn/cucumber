require 'cucumber/filter'

module Cucumber
  module Inputs
    class File

      # The +uri+ argument is the location of the source. It can ba a path 
      # or a path:line1:line2 etc. If +source+ is passed, +uri+ is ignored.
      def initialize(uri, source=nil)
        @source = source
        @path = uri
      end
      
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
