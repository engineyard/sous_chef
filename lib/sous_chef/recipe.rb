module SousChef
  class Recipe
    attr_accessor :node, :verbose, :shebang
    alias_method :verbose?, :verbose
    alias_method :shebang?, :shebang

    def initialize(*flags, &block)
      flags.each {|flag| __send__("#{flag}=", true)}
      @resources = []
      @block = block
    end

    def self.load(file)
      new { instance_eval(File.read(file), file, 1) }
    end

    def setup
      if @block
        instance_eval &@block
        @block = nil
      end
    end

    def to_script
      @script ||= begin
        setup
        lines = []
        lines << "#!/bin/bash" if shebang?
        lines += @resources.map do |resource|
          # @context = resource
          script = ""
          script << %{# #{resource.name}\n} if verbose? && resource.name
          script << resource.to_script
        end
        # add a trailing newline for consistency and vim-friendliness
        lines.join("\n\n") << "\n"
      end
    end

    def echo(string)
      command "echo '#{escape_string(string)}'"
    end

    def execute(*args, &block)
      add_resource Resource::Execute.new(self, *args, &block)
    end

    def file(*args, &block)
      add_resource Resource::File.new(self, *args, &block)
    end

    def directory(*args, &block)
      add_resource Resource::Directory.new(self, *args, &block)
    end

    def log(*args, &block)
      add_resource Resource::Log.new(self, *args, &block)
    end

    def gemfile(*args, &block)
      add_resource Resource::Gemfile.new(self, *args, &block)
    end

    def command(cmd)
      if context
        context.command(cmd)
      else
        execute { command cmd }
      end
    end

    def halt_on_failed_command
      execute "halt on failed command" do
        command "set -e"
      end
    end

    def add_resource(resource)
      with_context(resource) do
        @resources << resource
        resource.setup
      end
      resource
    end

    def context
      @context
    end

    def with_context(resource)
      @context = resource
      yield
      @context = nil
    end

    def escape_path(path)
      path
    end

    def escape_string(string)
      # bash is completely insane
      # this stops the quote, immediately starts another one using
      # double quotes to insert the single quote, then resumes the
      # single quote again until the terminating single quote
      return if string.nil?
      string.gsub("'", %q{'"'"'})
    end

    def method_missing(meth, *args, &block)
      if context && context.resource_respond_to?(meth)
        context.__send__(meth, *args, &block)
      else
        super
      end
    end
  end
end
