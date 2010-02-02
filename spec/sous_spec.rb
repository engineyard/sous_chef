require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SousChef do
  describe "execute" do
    it "returns a simple command" do
      script = SousChef.prep do
        execute "run a command" do
          command "ls"
        end
      end
      script.should == "ls"
    end

    it "concatenates multiple commands" do
      script = SousChef.prep do
        execute "run multiple commands" do
          command "curl -O http://www.example.com/file.tgz"
          command "tar xvfz file.tgz"
        end
      end
      script.should == "curl -O http://www.example.com/file.tgz\ntar xvfz file.tgz"
    end

    it "respects multiline commands" do
      script = SousChef.prep do
        execute "run multiline commands" do
          command <<-CODE
curl -O http://www.example.com/file.tgz
tar xvfz file.tgz
          CODE
        end
      end
      script.should == "curl -O http://www.example.com/file.tgz\ntar xvfz file.tgz"
    end

    it "changes current working directory on cwd" do
      script = SousChef.prep do
        execute "change directory" do
          cwd "/home/user"
        end
      end
      script.should == %{cd "/home/user"}
    end

    it "changes the current working directory before any commands" do
      script = SousChef.prep do
        execute "change directory before commands" do
          command "cp foo bar"
          cwd "/home/user"
        end
      end
      script.should == %{cd "/home/user"\ncp foo bar}
    end

    it "can use a method defined within the prep block" do
      script = SousChef.prep do
        def report(message)
          command "echo #{message}"
        end

        execute "say the date" do
          report "`date`"
        end
      end
      script.should == %{echo `date`}
    end

    it "scopes cwd to the correct execute block" do
      script = SousChef.prep do
        execute "install bundler" do
          command "gem install bundler"
        end

        execute "bundle some project" do
          cwd "/data/projects/foo"
          command "gem bundle"
        end
      end
      script.should == %{gem install bundler\n\ncd "/data/projects/foo"\ngem bundle}
    end

    it "wraps commands in an if block on not_if" do
      script = SousChef.prep do
        execute "bundle some project" do
          cwd "/data/projects/foo"
          command "gem bundle"
          not_if "test -d /data/projects/foo/vendor"
        end
      end
      script.should == %{
if ! test -d /data/projects/foo/vendor; then
  cd "/data/projects/foo"
  gem bundle
fi
      }.strip
    end

    it "wraps commands in an if block with test -e on creates" do
      script = SousChef.prep do
        execute "bundle some project" do
          creates "/data/projects/foo/vendor"
          cwd "/data/projects/foo"
          command "gem bundle"
        end
      end
      script.should == %{
if ! test -e "/data/projects/foo/vendor"; then
  cd "/data/projects/foo"
  gem bundle
fi
      }.strip
    end
  end
end
