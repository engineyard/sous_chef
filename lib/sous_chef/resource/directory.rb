module SousChef
  module Resource
    class Directory < Base
      ACTIONS = %w[create delete]

      def initialize(*args)
        action :create
        force false
        super
      end

      def path(path=nil)
        set_or_return(:path, path) || name
      end

      def mode(mode=nil)
        set_or_return(:mode, mode)
      end

      def action(action=nil)
        set_or_return(:action, action && validate_action(action))
      end

      def force(forced)
        @forced = forced
      end

      def forced?
        @forced
      end

      def to_script
        @script ||= begin
          setup
          __send__(action)
          [super, mode_command].compact.join("\n")
        end
      end

      protected
        def create
          command %{mkdir -p #{escape_path(path)}}
        end

        def delete
          cmd = forced?? 'rm -rf' : 'rmdir'
          command %{#{cmd} #{escape_path(path)}}
        end

        def validate_action(action)
          return action if ACTIONS.include?(action.to_s)
          raise ArgumentError, "Invalid action #{action}, only #{ACTIONS.join(', ')} allowed"
        end

        def mode_command
          if mode
            sprintf(%{chmod %04o %s}, mode, escape_path(path))
          end
        end
    end
  end
end
