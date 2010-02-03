module SousChef
  module Resource
    autoload :Directory, 'sous_chef/resource/directory'
    autoload :Execute,   'sous_chef/resource/execute'
    autoload :File,      'sous_chef/resource/file'
    autoload :Log,       'sous_chef/resource/log'

    class Base
      attr_reader :name

      def initialize(context, name, &block)
        @context = context
        @name = name
        @block = block
      end

      alias_method :resource_respond_to?, :respond_to?
      def respond_to?(meth)
        super || context.respond_to?(meth)
      end

      protected
        attr_reader :block, :context

        def method_missing(meth, *args, &block)
          if context.respond_to?(meth)
            context.__send__(meth, *args, &block)
          else
            super
          end
        end

        def escape_path(path)
          path
        end

        def escape_string(string)
          # many slashes because single-quote has some sort of
          # special meaning in regexp replacement strings
          string && string.gsub(/'/, %q{\\\\'})
        end
    end
  end
end
