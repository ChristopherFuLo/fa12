class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1}
  def method_missing(method_id, *args)
    if method_id.to_s.eq? "in"
        method_id = *args[0]
    end
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      super
    end
  end
end

class String
   def palindrome?(str)
      forward = str.gsub(/\W/,'').downcase
      forward.eql? forward.reverse
   end
end

module Enumerable
   def palindrome?(obj) #hashes don't have length, what shoudl i do
        (1..obj.length).each {|i|  if obj[i] != obj[-i] { return false} }
    return true
   end
end
