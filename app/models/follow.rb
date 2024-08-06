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
		follow = where(url_id: activity["object"])

		new_actor = activity_get(activity["target"])
		if new_actor["alsoKnownAs"].include?(activity["object"])
			uri = URI.parse(new_actor["id"])
			follow.update_all(
				url_id: uri.to_s,
				host: uri.host,
				username: uri.path.split("/").last,
				inbox: new_actor["inbox"],
				shared_inbox: new_actor.dig("endpoints", "sharedInbox")
			)
		end
	end

	def self.find_by_activity(actor, object)
		where(url_id: actor, letter: letter_from_url(object))
	end

	def self.letter_from_url(url)
		LetterHandler.get_letter(url.match(/letters\/(.*)$/)[1])
	end

	def self.where_handle(handle)
		where(letter: LetterHandler.get_letter(handle))
	end
	
	def allowed_host
		if BanHost.exists?(name: host)
			errors.add(:host, "is not allowed by this instance.")
		end
	end

	def handle
		LetterHandler.get_handle(letter)
	end
end
