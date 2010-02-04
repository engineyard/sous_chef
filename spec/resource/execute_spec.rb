require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::Execute do
  it "formats multiline commands that are wrapped in not_if" do
    execute = resource("clone sous_chef") do
      command <<-EOS
git clone git://github.com/engineyard/sous_chef.git
cd sous_chef
gem bundle
EOS
      not_if 'test -d sous_chef'
    end
    execute.to_script.should == %{
if ! test -d sous_chef; then
  git clone git://github.com/engineyard/sous_chef.git
  cd sous_chef
  gem bundle
fi
    }.strip
  end
end
