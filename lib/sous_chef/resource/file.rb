module SousChef
  module Resource
    class File < Directory
      def content(content=nil)
        set_or_return(:content, content && content.to_s)
      end

      protected
        def escaped_content
          content
        end

        def create
          not_if file_exist_command unless forced?
          command create_file_command
        end

        def delete
          only_if file_exist_command unless forced?
          command "rm #{'-f ' if forced?}#{escape_path(path)}"
        end

        def file_exist_command
          %{test -e #{escape_path(path)}}
        end

        def heredoc
          @heredoc ||= begin
            candidate = "SousChefHeredoc"
            candidate += "1" while content.include?(candidate)
            candidate
          end
        end

        def create_file_command
          if content
            lines = []
            lines << "cat <<'#{heredoc}' > #{escape_path(path)}"
            lines << escaped_content
            lines << heredoc
            lines.join("\n")
          else
            %{touch #{escape_path(path)}}
          end
        end
    end
  end
end
