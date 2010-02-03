module SousChef
  module Resource
    class File < Directory
      def content(content=nil)
        set_or_return(:content, content)
      end

      protected
        def escaped_content
          escape_string(content)
        end

        def create
          not_if file_exist_command
          command create_file_command
        end

        def delete
          only_if file_exist_command
          command "rm #{escape_path(path)}"
        end

        def file_exist_command
          %{test -e #{escape_path(path)}}
        end

        def create_file_command
          if content
            %{echo '#{escaped_content}' > #{escape_path(path)}}
          else
            %{touch #{escape_path(path)}}
          end
        end
    end
  end
end
