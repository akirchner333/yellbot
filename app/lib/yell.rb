class Yell
	def self.yell(letter)
		r = Random.new()
		case r.rand(0..3)
		when 0
			exclamations(letter, r)
		when 1
			single(letter, r)
		when 2
			sentence(letter, r)
		when 3
			single(letter, r)
		end
	end

	def self.exclamations(letter, r)
		output = []
		(r.rand(5) + 1).times do |i|
			output[i] = letter * r.rand(1..9) + punctuation
		end
		output.join(" ")
	end

	def self.single(letter, r)
		letter * r.rand(1..100) + "!" * r.rand(5)
	end

	def self.sentence(letter, r)
		output = []
		(r.rand(5) + 1).times do |i|
			output[i] = letter * r.rand(1..9)
		end

		output.join(" ") + punctuation
	end

	def self.punctuation
		%w[! ? . ...].sample
	end

	def self.single(letter, r)
		letter
	end
end