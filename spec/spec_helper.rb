$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sous_chef'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  def resource(*args, &block)
    described_class.new(SousChef::Recipe.new, *args, &block)
  end
end
