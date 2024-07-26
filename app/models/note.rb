include ActivityPubHelper

class Note < ApplicationRecord
	validates :letter, presence: true, length: { is: 1 }
	validates :content, presence: true

	after_create_commit :send_to_pub

	def self.generate(letter)
		create(letter: letter, content: Yell.yell(letter))
	end

	def to_activity
		Pub::Note.from_model(self)
	end

	private
	def send_to_pub
		body = to_activity.to_s
		Follow.where(letter: letter).shared_inboxes.each do |inbox|
			activity_post(inbox, body, letter)
		end
	end
end
