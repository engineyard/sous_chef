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
        @recipe.to_script.should == "# run ls\nls\n"
      end
    end

    describe "shebang" do
      before do
        @recipe = SousChef::Recipe.new(:shebang) do
          execute "run ls" do
            command "ls"
          end
        end
      end

      it "has shebang set" do
        @recipe.should be_shebang
      end

      it "includes a shebang line" do
        @recipe.to_script.should == "#!/bin/bash\n\nls\n"
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

  describe ".load" do
    before do
      @recipe = SousChef::Recipe.load(File.dirname(__FILE__) + '/fixtures/deploy_command.rb')
      @recipe.node = { :config => {}, :chef_args => "--main" }
    end

    it "loads a recipe from a file" do
      @recipe.to_script.should == File.read(File.dirname(__FILE__) + '/fixtures/deploy_command_expected.sh')
    end
  end
end
