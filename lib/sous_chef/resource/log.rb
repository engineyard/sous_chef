module SousChef
  module Resource
    class Log < Base
      def initialize(context, name=nil, &block)
        super

        @stdout = nil
        @stderr = nil
      end

      def stdout(stdout=nil)
        if stdout.nil?
          @stdout
        else
          @stdout = stdout
        end
      end

      def stderr(stderr=nil)
        if stderr.nil?
          @stderr
        else
          @stderr = stderr
        end
      end

      def to_script
        @script ||= begin
          if block
            instance_eval(&block)
          else
            @stdout, @stderr = name, "&1"
          end
          exec_command(escape_path(@stdout), escape_path(@stderr))
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
