class Follow < ApplicationRecord
	validates :letter, presence: true, length: { is: 1 }
	validate :allowed_host

	def self.create_from_activity(activity)
		uri = URI.parse(activity["actor"])
		actor = get_actor_from_url(activity["actor"])
		find_or_create_by(
			url_id: uri.to_s,
			host: uri.host,
			username: uri.path.split("/").last,
			letter: letter_from_url(activity["object"]),
			inbox: actor["inbox"],
			shared_inbox: actor.dig("endpoints", "sharedInbox")
		)
	end

	def self.get_actor_from_url(url)
		response = HTTP.headers(
			'Content-Type' => 'application/activity+json',
			'Accept': 'application/activity+json'
		).get(url)
		JSON.parse(response.to_s)
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
