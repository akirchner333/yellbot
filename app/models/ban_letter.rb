class BanLetter < ApplicationRecord
	def self.banned?(letter)
		exists?(letter: letter) ? nil : letter
	end
end
