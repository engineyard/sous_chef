module SousChef
  module Resource
    class Execute < Base
      def initialize(context, name, &block)
        super

        @commands = []
        @cwd = nil
        @not_if_cmd = nil
      end

      def to_script
        @script ||= begin
          instance_eval(&block)

          lines = @commands.dup
          lines.unshift(%{cd #{escape_path(@cwd)}}) if @cwd
          lines = lines.inject([]) do |result, line|
            result + line.split("\n")
          end

          if @not_if_cmd
            lines.map! { |line| "  #{line}" }
            lines.unshift "if ! #{@not_if_cmd}; then"
            lines.push    "fi"
          end
          lines.map! { |line| line.rstrip }

          lines.join("\n")
        end
      end

      def cwd(dir)
        @cwd = dir
      end

      def command(cmd)
        @commands << cmd
      end

      def not_if(cmd)
        @not_if_cmd = cmd
      end

      def creates(path)
        @not_if_cmd = %{test -e #{escape_path(path)}}
      end
    end
  end
end
