require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::Gemfile do
  it "uses the name as the path without an explicit path" do
    gemfile = resource('/path/to/project/Gemfile')
    gemfile.path.should == '/path/to/project/Gemfile'
  end

  it "uses an explicit path if one is given" do
    gemfile = resource('My Project dependencies') do
      path '/path/to/project/Gemfile'
    end
    gemfile.to_script # evaluate the block
    gemfile.path.should == '/path/to/project/Gemfile'
  end

  it "appends Gemfile to the path if it isn't there" do
    gemfile = resource('/path/to/project')
    gemfile.path.should == '/path/to/project/Gemfile'
  end
end
