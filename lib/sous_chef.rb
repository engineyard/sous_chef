module SousChef
  def self.prep(*flags, &block)
    recipe = Recipe.new(*flags, &block)
    recipe.to_script
  end
end

require 'sous_chef/recipe'
require 'sous_chef/resource'
