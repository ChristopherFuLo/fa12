class CartesianProduct
  include Enumerable
   def initialize(vecA, vecB)
    @vecA = vecA
    @vecB = vecB
    @product = []
    if vecA.length != 0 and vecB.length !=0
        vecA.each do |a|
            vecB.each do |b|
                @product.push([a,b])
            end
        end
    end
  end
  
  def each
    0.upto(@product.length - 1) do |x|
        yield @product[x]
    end
  end
 
end
