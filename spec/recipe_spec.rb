require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SousChef::Recipe do
  context "flags" do
    describe "verbose" do
      before do
        @recipe = SousChef::Recipe.new(:verbose) do
          execute "run ls" do
            command "ls"
          end
        end
      end

      it "is verbose" do
        @recipe.should be_verbose
      end

      it "includes comments" do
        @recipe.to_script.should == "# run ls\nls"
      end
    end
  end

  it "doesn't change the script when run twice" do
    recipe = SousChef::Recipe.new do
      execute "change directory before commands" do
        command "cp foo bar"
        cwd "/home/user"
      end
    end
    recipe.to_script.should == recipe.to_script
  end
end
