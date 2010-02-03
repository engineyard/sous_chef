module SousChef
  module Resource
    class Log < Base
      def initialize(context, name=nil, &block)
        super

        @stdout = nil
        @stderr = nil
      end

      def stdout(stdout=nil)
        set_or_return(:stdout, stdout)
      end

      def stderr(stderr=nil)
        set_or_return(:stderr, stderr)
      end

      def to_script
        @script ||= begin
          setup
          unless @stdout || @stderr
            @stdout, @stderr = name, "&1"
          end
          append exec_command(escape_path(@stdout), escape_path(@stderr))
          super
        end
      end

      protected
        def exec_command(stdout, stderr)
          args = []
          args << "1>#{escape_path(stdout)}" if stdout
          args << "2>#{escape_path(stderr)}" if stderr
          "exec #{args.join(' ')}"
        end
    end
  end
end
