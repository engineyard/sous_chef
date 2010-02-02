require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::Directory do
  before do
    @directory = SousChef::Resource::Directory.new(nil, "bin") do
    end
    @directory.to_script # evaluate the block
  end

  it "has a name" do
    @directory.name.should == "bin"
  end

  it "has a path equal to the name when no explicit path is given" do
    @directory.path.should == "bin"
  end

  it "has a path as set when an explicit path is given" do
    @directory = SousChef::Resource::Directory.new(nil, "bin") do
      path "/home/user/bin"
    end
    @directory.to_script # evaluate the block
    @directory.path.should == "/home/user/bin"
  end

  it "creates the directory" do
    @directory.to_script.should == %{mkdir -p "bin"}
  end

  it "sets the mode of the file" do
    @directory = SousChef::Resource::Directory.new(nil, "bin") do
      mode 0600
    end

    @directory.to_script.should == %q{
mkdir -p "bin"
chmod 0600 "bin"
    }.strip
  end
end
