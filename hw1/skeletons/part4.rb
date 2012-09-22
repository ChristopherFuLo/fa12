class Dessert
  
  def initialize(name, calories)
    @name = name
    @calories = calories
    attr_accessor :name
    attr_accessor :calories
  end
  
  def healthy?
    self.calories < 200
  end
  
  def delicious?
    true
  end
end

class JellyBean < Dessert
  def initialize(name, calories, flavor)
    @name = name
    @calories = calories
    @flavor = flavor
    attr_accessor :name
    attr_accessor :calories
    attr_accessor :flavor
  end
  
  def delicious?
    self.flavor != "black licorice"
  end
end
