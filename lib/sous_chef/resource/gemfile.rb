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

          max_name_size = 0
          @gems.each {|name,| max_name_size = [max_name_size, name.size].max}

          @gems.sort_by {|name,| name.downcase}.each do |name, version|
            if version.nil?
              result.puts %{gem "#{name}"}
            else
              width = max_name_size + 3 # 2 quotes + comma
              result.printf %{gem %-#{width}s "%s"\n}, %{"#{name}",}, version
            end
          end

          result.string.strip
        end
    end
  end
end
