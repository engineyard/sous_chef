require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::File do
  before do
    @file = resource("note.txt") do
      content "this is a note"
    end
    @file.setup # evaluate the block
  end

  it "has a name" do
    @file.name.should == "note.txt"
  end

  it "has a path equal to the name when no explicit path is given" do
    @file.path.should == "note.txt"
  end

  it "has a path as set when an explicit path is given" do
    @file = resource("note.txt") do
      path "/home/user/note.txt"
      content "this is a note"
    end
    @file.setup # evaluate the block
    @file.path.should == "/home/user/note.txt"
  end

  it "has content as set when explicit content is given" do
    @file.content.should == "this is a note"
  end

  it "has nil content when no content is given" do
    @file = resource("note.txt")
    @file.setup # evaluate the block
    @file.content.should == nil
  end

  it "cats content to file" do
    @file.to_script.should == %{
if ! test -e note.txt; then
  cat <<'SousChefHeredoc' > note.txt
this is a note
SousChefHeredoc
fi
    }.strip
  end

  it "handles single-quotes in the content" do
    @file = resource("note.txt") do
      content %{this is a 'note'}
    end
    @file.to_script.should == %q{
if ! test -e note.txt; then
  cat <<'SousChefHeredoc' > note.txt
this is a 'note'
SousChefHeredoc
fi
    }.strip
  end

  it "handles dollar signs in the content without allowing them to expand" do
    @file = resource("note.txt") do
      content %{export PATH=/my/bin:$PATH}
    end
    @file.to_script.should == <<-EOSH.chomp
if ! test -e note.txt; then
  cat <<'SousChefHeredoc' > note.txt
export PATH=/my/bin:$PATH
SousChefHeredoc
fi
    EOSH
  end

  it "changes it's heredoc if the content of the file contains the heredoc" do
    @file = resource("note.txt") do
      content %{SousChefHeredoc}
    end
    @file.to_script.should == <<-EOSH.chomp
if ! test -e note.txt; then
  cat <<'SousChefHeredoc1' > note.txt
SousChefHeredoc
SousChefHeredoc1
fi
    EOSH
  end

  it "handles newlines in the content" do
    @file = resource("note.txt") do
      content <<-EOS
This
is

a
NOTE
      EOS
    end
    @file.to_script.should == <<-EOSH.chomp
if ! test -e note.txt; then
  cat <<'SousChefHeredoc' > note.txt
This
is

a
NOTE

SousChefHeredoc
fi
    EOSH
  end

  it "outputs the path instead of the name if it exists" do
    @file = resource("note.txt") do
      path "/home/user/note.txt"
      content %{this is a note}
    end
    @file.to_script.should == %q{
if ! test -e /home/user/note.txt; then
  cat <<'SousChefHeredoc' > /home/user/note.txt
this is a note
SousChefHeredoc
fi
    }.strip
  end

  it "touches the file if the content is nil" do
    @file = resource("note.txt")
    @file.to_script.should == %q{
if ! test -e note.txt; then
  touch note.txt
fi
    }.strip
  end

  it "sets the mode of the file" do
    @file = resource("note.txt") do
      mode 0600
    end

    @file.to_script.should == %q{
if ! test -e note.txt; then
  touch note.txt
fi
chmod 0600 note.txt
    }.strip
  end

  it "deletes a file" do
    @file = resource("note.txt") do
      action :delete
    end

    @file.to_script.should == %q{
if test -e note.txt; then
  rm note.txt
fi
    }.strip
  end
end
