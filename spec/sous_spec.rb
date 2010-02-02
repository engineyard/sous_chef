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
  end
end
