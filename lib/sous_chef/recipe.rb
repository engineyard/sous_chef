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

    def echo(string)
      execute "echo #{string}" do
        command "echo '#{escape_string(string)}'"
      end
    end

    def execute(*args, &block)
      @resources << Resource::Execute.new(self, *args, &block)
    end

    def file(*args, &block)
      @resources << Resource::File.new(self, *args, &block)
    end

    def directory(*args, &block)
      @resources << Resource::Directory.new(self, *args, &block)
    end

    def log(*args, &block)
      @resources << Resource::Log.new(self, *args, &block)
    end

    def gemfile(*args, &block)
      @resources << Resource::Gemfile.new(self, *args, &block)
    end

    def halt_on_failed_command
      execute "halt on failed command" do
        command "set -e"
      end
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
