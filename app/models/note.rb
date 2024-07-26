class Note < ApplicationRecord
	validates :letter, presence: true, length: { is: 1 }
	validates :content, presence: true

	def self.generate(letter)
		create(letter: letter, content: Yell.yell(letter))
	end
end
