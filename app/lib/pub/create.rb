module Pub
	class Create < BaseObject
		Type = "Create"

		def initialize(action)
			@action = action
			@object = JSON.parse(action.object)
		end

		def id
			"#{full_url}/actions/#{@action.id}"
		end

		def to_h
			date = Time.now.utc.iso8601
			{
				**super,
				actor: @object["attributedTo"],
				published: date,
				to:[
					"https://www.w3.org/ns/activitystreams#Public"
				],
				cc: @object["cc"],
				object: @object,
				# https://docs.joinmastodon.org/spec/security/#ld
				# signature: {
				# 	type: "RSASignature2017",
				# 	creator: "#{@object["attributedTo"]}#main-key",
				# 	signatureValue: "???"
				# }
			}
		end
	end
end