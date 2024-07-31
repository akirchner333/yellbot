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
				id: id,
				type: self.class::Type,
				"@context": [self.class::Context]
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