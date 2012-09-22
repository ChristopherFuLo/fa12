def combine_anagrams(words)
	dict = Hash.new
	finalArray = []
 wordsSorted = words.map do |word|
  sortedWord = word.chars.sort { |a,b| a.casecmp(b) }.join
	dict[sortedWord] = word
 end
 newArray = []
 oldWord = ""
 first = true
 wordsSorted.each do |word|
	if oldWord.eq? word.downcase == false and first == false
		finalArray.push newArray
		newArray = []
	end
	newArray.push dict[word]
	oldWord = word
	first = false
 end
 if wordsSorted[-1].downcase.eq? wordsSorted[-2].downcase
	finalArray.push newArray
 end
 finalArray
end
