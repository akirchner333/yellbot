include ActivityPubHelper

class Follow < ApplicationRecord
	validates :letter, presence: true, length: { is: 1 }
	validate :allowed_host

	def self.create_from_activity(activity)
		uri = URI.parse(activity["actor"])
		actor = activity_get(activity["actor"])
		find_or_create_by(
			url_id: uri.to_s,
			host: uri.host,
			username: uri.path.split("/").last,
			letter: letter_from_url(activity["object"]),
			inbox: actor["inbox"],
			shared_inbox: actor.dig("endpoints", "sharedInbox")
		)
	end

	def self.move(activity)
		# Find the relevant follow
		# Check the new (old?) account to see if it's transfer is in place
		# If yes, update the relevant follow
	end

	def self.find_by_activity(actor, object)
		where(url_id: actor, letter: letter_from_url(object))
	end

	def self.letter_from_url(url)
		LetterHandler.get_letter(url.match(/letters\/(.)$/)[1])
	end
	
	def allowed_host
		if BanHost.exists?(name: host)
			errors.add(:host, "is not allowed by this instance.")
		end
	end
end
