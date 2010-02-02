module SousChef
  autoload :Recipe,   'sous_chef/recipe'
  autoload :Resource, 'sous_chef/resource'

  def self.prep(*flags, &block)
    recipe = Recipe.new(*flags, &block)
    recipe.to_script
  end
end
