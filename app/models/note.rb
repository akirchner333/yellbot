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
		actor = activity["actor"]
		create(
			letter: replying_to.letter,
			content: "<a href=\"#{actor}\">@#{actor.split("/").last}</a> #{Yell.yell(replying_to.letter)}",
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

	def handle
		LetterHandler.get_handle(letter)
	end

	private
	def send_to_pub
		action = Action.create(
			activity_type: 'create_note',
			actor: "#{full_url}/letters/#{handle}",
			object: to_activity.to_s,
		)
		Follow.where(letter: letter).each do |follower|
			response = activity_post(follower.inbox, action.to_activity, letter)
		end
	end
end
