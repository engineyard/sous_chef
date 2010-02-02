require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::File do
  before do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      content "this is a note"
    end
    @file.to_script # evaluate the block
  end

  it "has a name" do
    @file.name.should == "note.txt"
  end

  it "has a path equal to the name when no explicit path is given" do
    @file.path.should == "note.txt"
  end

  it "has a path as set when an explicit path is given" do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      path "/home/user/note.txt"
      content "this is a note"
    end
    @file.to_script # evaluate the block
    @file.path.should == "/home/user/note.txt"
  end

  it "has content as set when explicit content is given" do
    @file.content.should == "this is a note"
  end

  it "has nil content when no content is given" do
    @file = SousChef::Resource::File.new(nil, "note.txt") {}
    @file.to_script # evaluate the block
    @file.content.should == nil
  end

  it "echos content to file" do
    @file.to_script.should == %{
if ! test -e "note.txt"; then
  echo 'this is a note' > "note.txt"
fi
    }.strip
  end

  it "handles single-quotes in the content" do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      content %{this is a 'note'}
    end
    @file.to_script.should == %q{
if ! test -e "note.txt"; then
  echo 'this is a \'note\'' > "note.txt"
fi
    }.strip
  end

  it "handles dollar signs in the content without allowing them to expand" do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      content %{export PATH=/my/bin:$PATH}
    end
    @file.to_script.should == %q{
if ! test -e "note.txt"; then
  echo 'export PATH=/my/bin:$PATH' > "note.txt"
fi
    }.strip
  end

  it "handles newlines in the content" do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      content <<-EOS
This
is

a
NOTE
      EOS
    end
    @file.to_script.should == %q{
if ! test -e "note.txt"; then
  echo 'This
is

a
NOTE
' > "note.txt"
fi
    }.strip
  end

  it "outputs the path instead of the name if it exists" do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      path "/home/user/note.txt"
      content %{this is a note}
    end
    @file.to_script.should == %q{
if ! test -e "/home/user/note.txt"; then
  echo 'this is a note' > "/home/user/note.txt"
fi
    }.strip
  end

  it "touches the file if the content is nil" do
    @file = SousChef::Resource::File.new(nil, "note.txt") {}
    @file.to_script.should == %q{
if ! test -e "note.txt"; then
  touch "note.txt"
fi
    }.strip
  end

  it "sets the mode of the file" do
    @file = SousChef::Resource::File.new(nil, "note.txt") do
      mode 0600
    end

    @file.to_script.should == %q{
if ! test -e "note.txt"; then
  touch "note.txt"
fi
chmod 0600 "note.txt"
    }.strip
  end
end
