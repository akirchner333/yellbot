module Pub
	class Create < BaseObject
		Type = "Create"

		def initialize(action, note)
			@note = note
			@action = action
		end

		def id
			"#{full_url}/actions/#{@action.id}"
		end

		def to_h
			date = Time.now.utc.iso8601
			{
				**super,
				actor:"#{full_url}/letters/#{@note.letter}",
				published: date,
				to:[
					"https://www.w3.org/ns/activitystreams#Public"
				],
				cc:[
					"#{full_url}/pub/actor/#{@actor}/collections/followers",
					@note.reply_actor
				].compact,
				object: @note.to_activity.to_h,
				# signature: {
				# 	"type":"RsaSignature2017",
				# 	"creator":"https://#{ENV['URL']}/pub/actor/lazar#main-key",
				# 	"created": date,
				# 	"signatureValue":"????"
				# }
			}
		end
	end
end