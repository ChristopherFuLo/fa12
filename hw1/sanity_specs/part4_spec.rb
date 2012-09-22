describe "dessert" do
  it "should have an initialize method" do
    lambda { Dessert.new }.should_not raise_error(::NoMethodError)
  end

  it "should have a healthy? method" do
    lambda { Dessert.new('a', 1).healthy? }.should_not raise_error(::NoMethodError)
  end

  it "should have a delicious? method" do
    lambda { Dessert.new('a', 1).delicious? }.should_not raise_error(::NoMethodError)
  end
end

describe "jellybean" do
  it "should have an initialize method" do
    lambda { Dessert.new }.should_not raise_error(::NoMethodError)
  end

  it "should have a healthy? method" do
    lambda { Dessert.new('a', 1).healthy? }.should_not raise_error(::NoMethodError)
  end

  it "should have a delicious? method" do
    lambda { Dessert.new('a', 1).delicious? }.should_not raise_error(::NoMethodError)
  end
end
