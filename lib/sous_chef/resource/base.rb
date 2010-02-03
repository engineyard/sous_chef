module SousChef
  module Resource
    class Base
      attr_reader :name

      def initialize(context, name, &block)
        @context = context
        @name = name
        @block = block
        @only_if = nil
        @commands = []
      end

      def setup
        if @block
          instance_eval &@block
          @block = nil
        end
      end

      def not_if(cmd=nil)
        only_if "! #{cmd}"
      end

      def only_if(cmd=nil)
        if cmd
          @only_if = cmd
        else
          @only_if
        end
      end

      alias_method :resource_respond_to?, :respond_to?
      def respond_to?(meth)
        super || context.respond_to?(meth)
      end

      def prepend(cmd)
        @commands.unshift(cmd)
      end

      def append(cmd)
        @commands.push(cmd)
      end

      alias_method :command, :append

      def to_script
        setup
        if only_if
          @commands.compact!
          @commands.map! { |line| "  #{line}" }
          prepend "if #{only_if}; then"
          append  "fi"
        end
        @commands.join("\n").strip
      end

      protected
        attr_reader :context

        def set_or_return(attr, val)
          if val.nil?
            instance_variable_get("@#{attr}")
          else
            instance_variable_set("@#{attr}", val)
          end
        end

        def method_missing(meth, *args, &block)
          if context.respond_to?(meth)
            context.__send__(meth, *args, &block)
          else
            super
          end
        end
    end
  end
end
