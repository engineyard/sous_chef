module SousChef
  module Resource
    class Execute < Base
      def initialize(context, name=nil, &block)
        super

        @cwd = nil
      end

      def to_script
        @script ||= begin
          prepend %{cd #{escape_path(@cwd)}} if @cwd
          @commands = @commands.inject([]) do |result, line|
            result + line.split("\n")
          end
          super
        end
      end

      def cwd(dir=nil)
        set_or_return(:cwd, dir)
      end

      def command(cmd)
        @commands << cmd
      end

      def creates(path)
        not_if %{test -e #{escape_path(path)}}
      end
    end
  end
end
