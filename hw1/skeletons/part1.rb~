def palindrome?(str)
  forward = str.gsub(/\W/,'').downcase
  forward.eql? forward.reverse
end

def count_words(str)
    dict = {}
   str.gsub(/\W/,' ').downcase.split.each do |word|
      if dict[word]
        dict[word] += 1
      else
        dict[word] = 1
      end
   end
   dict
end
