module SousChef
  module Resource
    class Directory < Base
      attr_reader :name

      def initialize(context, name, &block)
        super
      end

      def path(path=nil)
        if path.nil?
          @path || name
        else
          @path = path
        end
      end

      def mode(mode=nil)
        if mode.nil?
          @mode
        else
          @mode = mode
        end
      end

      def to_script
        @script ||= begin
          instance_eval(&block) if block
          %{
mkdir -p #{escape_path(path)}
#{mode_command}
          }.strip
        end
      end

      protected
        def mode_command
          if mode
            sprintf(%{chmod %04o %s}, mode, escape_path(path))
          end
        end
    end
  end
end
