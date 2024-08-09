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

		return if BanHost.exists?(name: id_host(activity["actor"]))
		
		# Don't reply to the same person twice in the same 10 minute period
		prev_reply = where(reply_actor: activity["actor"]).order(created_at: :desc).first
		return if prev_reply && prev_reply.created_at > 10.minutes.ago

		actor = activity["actor"]
		create(
			letter: replying_to.letter,
			content: Yell.yell(replying_to.letter),
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
			activity_post(follower.inbox, action.to_activity, handle)
		end

		if !reply_actor.nil? && !Follow.exists?(letter: letter, url_id: reply_actor)
			activity_post("#{reply_actor}/inbox", action.to_activity, letter)
		end
	end
end
