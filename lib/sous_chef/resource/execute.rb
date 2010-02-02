module SousChef
  module Resource
    class Execute
      attr_reader :name

      def initialize(context, name, &block)
        @context = context
        @commands = []
        @cwd = nil
        @not_if_cmd = nil
        @block = block
        @name = name
      end

      def to_script
        @script ||= begin
          instance_eval(&@block)

          lines = @commands.dup
          lines.unshift(%{cd "#{@cwd}"}) if @cwd
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
        @not_if_cmd = %{test -e "#{path}"}
      end

      alias_method :resource_respond_to?, :respond_to?
      def respond_to?(meth)
        super || @context.respond_to?(meth)
      end

      protected
        def method_missing(meth, *args, &block)
          if @context.respond_to?(meth)
            @context.__send__(meth, *args, &block)
          else
            super
          end
        end
    end
  end
end
