module SousChef
  class Recipe
    def initialize(*flags, &block)
      @flags = flags
      @resources = []
      instance_eval(&block)
    end

    def to_script
      @resources.map do |resource|
        @context = resource
        script = ""
        script << %{# #{resource.name}\n} if verbose? && resource.name
        script << resource.to_script
      end.join("\n\n")
    end

    def verbose?
      @flags.include?(:verbose)
    end

    def execute(name = nil, &block)
      @resources << Resource::Execute.new(self, name, &block)
    end

    protected
      def method_missing(meth, *args, &block)
        if @context && @context.resource_respond_to?(meth)
          @context.__send__(meth, *args, &block)
        else
          super
        end
      end
  end
end
