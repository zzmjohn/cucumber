module Cucumber
  module RbSupport
    class Options
      def initialize
        @options = []
      end

      def method_missing(name, *args)
        unless invalid_option?(args)
          @options << "--#{argument_name(name)}"
          @options << args[0] if valid_argument?(args)
        end
      end

      def list
        @options
      end

      private
      def argument_name(name)
        name = name.to_s
        name = name[0..-2] if (name[-1].chr == '=')
        name
      end

      def invalid_option?(args)
        args && !args.empty? && args[0] == false
      end

      def valid_argument?(args)
        (!args.nil? && !args.empty?) && (args[0] != true)
      end

    end
  end
end