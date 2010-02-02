module SousChef
  def self.prep(&block)
    recipe = Recipe.new(&block)
    recipe.to_script
  end

  class Recipe
    def execute(name, &block)
      Execute.new(name, &block)
    end
  end
end
