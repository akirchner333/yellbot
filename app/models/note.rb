include ActivityPubHelper

class Note < ApplicationRecord
	validates :letter, presence: true, length: { is: 1 }
	validates :content, presence: true

	after_create :send_to_pub

	def self.generate(letter)
		create(letter: letter, content: Yell.yell(letter))
	end

	def send_to_pub
		body = Pub::Note.from_model(self).to_s
		Follow.where(letter: letter).shared_inboxes do |inbox|
			activity_post(inbox, body, letter)
		end
	end
end
