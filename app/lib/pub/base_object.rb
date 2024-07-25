module Pub
	class BaseObject
		include ActivityPubHelper

		Context = "https://www.w3.org/ns/activitystreams"
		Type = "Object"

		def id
			"#{full_url}"
		end

		def to_h
			{
				"@context": self.class::Context,
				type: self.class::Type,
				id: id
			}
		end

		def to_s
			JSON.generate(to_h)
		end

		def to_json(options)
			JSON.generate(to_h, **options)
		end
	end
end