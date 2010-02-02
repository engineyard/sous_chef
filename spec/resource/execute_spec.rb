require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::Execute do
  before do
    @execute = SousChef::Resource::Execute.new(nil, "install bundler") do
      command "gem install bundler"
    end
  end

  it "has a name" do
    @execute.name.should == "install bundler"
  end

  it "responds to a method its context responds to" do
    @context = stub(:foobar => 5)
    @execute = SousChef::Resource::Execute.new(@context, "install bundler") do
      command "gem install bundler"
    end
    @execute.should respond_to(:foobar)
  end

  it "delegates missing methods to its context when it responds" do
    @context = stub(:foobar => 5)
    @execute = SousChef::Resource::Execute.new(@context, "install bundler") do
      command "gem install bundler"
    end
    @execute.foobar.should == 5
  end

  it "does not resource_respond_to? a method its context responds to" do
    @context = stub(:foobar => 5)
    @execute = SousChef::Resource::Execute.new(@context, "install bundler") do
      command "gem install bundler"
    end
    @execute.should_not be_resource_respond_to(:foobar)
  end
end
