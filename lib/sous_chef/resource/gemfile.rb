require 'stringio'

module SousChef
  module Resource
    class Gemfile < File
      def initialize(context, name, &block)
        super
        @gems = []
        @sources = []
      end

      def gem(name, version=nil)
        @gems << [name, version]
      end

      def source(url)
        @sources << url
      end

      # override
      def path(path=nil)
        if path
          super
        else
          gemfile = super
          gemfile = "#{gemfile}/Gemfile" unless gemfile.split('/').last == "Gemfile"
          gemfile
        end
      end

      protected
        # override
        def content
          result = StringIO.new
          if @sources.any?
            @sources.each { |url| result.puts %{source "#{url}"} }
            result.puts
          end

          @gems.each do |name, version|
            result.print %{gem "#{name}"}
            result.print %{, "#{version}"} if version
            result.puts
          end

          result.string.strip
        end
    end
  end
end
