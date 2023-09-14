module RandomParamsHelper
	def random_alphbet_sequence(len)
		Array.new(len){rand(26)}.map{|n| ('a'..'z').to_a[n] }.join()
	end

	def random_user_params
		{
			name: Faker::Name.last_name,
			email: Faker::Internet.free_email
		}
	end
end