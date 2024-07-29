include ActivityPubHelper

class Note < ApplicationRecord
	has_many :likes
	
	validates :letter, presence: true, length: { is: 1 }
	validates :content, presence: true

	after_create_commit :send_to_pub

	def self.generate(letter)
		create(letter: letter, content: Yell.yell(letter))
	end

	def self.reply(activity)
		replying_to = Note.find_by_url(activity["object"]["inReplyTo"])

		# Putting href in there is rather ugly, so I might better
		# handle that on the Pub::Note side
		create(
			letter: replying_to.letter,
			content: "<a href=\"#{activity["actor"]}\">@#{actor.split("/").last}</a> #{Yell.yell(letter)}",
			reply_note: activity["object"]["id"],
			reply_actor: activity["actor"]
		)
	end

	def self.find_by_url(url)
		find(url.split("/").last.to_i)
	end

	def to_activity
		Pub::Note.new(self)
	end

	private
	def send_to_pub
		action = Action.create(
			activity_type: 'create_note',
			actor: "#{full_url}/letters/#{letter}",
			object: to_activity.to_s,
		)
		body = Pub::Create.new(action, self).to_h
		Follow.where(letter: letter).shared_inboxes.each do |inbox|
			activity_post(inbox, body, letter)
		end
	end
end
