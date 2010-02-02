module SousChef
  module Resource
    autoload :Execute, 'sous_chef/resource/execute'
    autoload :File,    'sous_chef/resource/file'

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
    end
  end
end
