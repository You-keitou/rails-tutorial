module MakeStringHelper
	def random_alphbet_sequence(len)
		Array.new(51){rand(26)}.map{|n| ('a'..'z').to_a[n] }.join()
	end
end