class Follow < ApplicationRecord
	validates :letter, presence: true, length: { is: 1 }

	def self.create_from_activity(activity)
		uri = URI.parse(activity["actor"])
		find_or_create_by(
			url_id: uri.to_s,
			host: uri.host,
			username: uri.path.split("/").last,
			letter: letter_from_url(activity["object"])
		)
	end

	def self.find_by_activity(actor, object)
		where(url_id: actor, letter: letter_from_url(object))
	end

	def self.letter_from_url(url)
		url.match(/letters\/(.)$/)[1]
	end

	def inbox
		url_id + "/inbox"
	end
end
