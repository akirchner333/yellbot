class Yell
	def self.yell(letter)
		r = Random.new()
		case r.rand(0..3)
		when 0
			exclamations(letter, r)
		when 1
			word(letter, r)
		when 2
			sentence(letter, r)
		when 3
			single(letter, r)
		end
	end

	def self.exclamations(letter, r)
		output = []
		(r.rand(5) + 1).times do |i|
			output[i] = letter * r.rand(2..12) + punctuation
		end
		output.join(" ")
	end

	def self.word(letter, r)
		letter * r.rand(2..100) + "!" * r.rand(5)
	end

	def self.sentence(letter, r)
		output = []
		(r.rand(5) + 1).times do |i|
			output[i] = letter * r.rand(1..9)
		end

		output.join(" ") + punctuation
	end

	def self.single(letter, r)
		"#{letter}#{punctuation}"
	end

	def self.punctuation
		%W[! ? !! !? ?! . ... #{}].sample
	end
end