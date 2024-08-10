module Pub
	class Service < SecureObject
		Type = "Service"

		def initialize(letter)
			super()

			@letter = letter
			@handle = LetterHandler.get_handle(letter)
			@summary = <<~HTML
			<p>
				#{Yell.yell(letter)}
			</p>
			HTML
			.gsub(/[\t\n]/, "")
			@name = letter
			@username = @handle
			@preferredUsername = @handle
			@url = id
			@icon = 'shouting.png'
			@published = "1960-11-24T00:00:00Z"
			@attachments = [
				{
					type: "PropertyValue",
					name: "Posts every",
					value: "Two Hours"
				},{
					type: "PropertyValue",
					name: "Address inquiries to",
					value: "@an_alexa_k@instance.digital"
				},{
					type: "PropertyValue",
					name: letter,
					value: letter
				}
			]
		end

		def id
			"#{full_url}/letters/#{@handle}"
		end

		def to_h
			{
				**super,
				"@context": [
					"https://www.w3.org/ns/activitystreams",
					"https://w3id.org/security/v1",
					{
						featured: {
							"@id": "toot:featured",
							"@type": "@id"
						}
					}
				],
				followers: "#{full_url}/letters/#{@username}/followers",
				following: "#{full_url}/letters/#{@username}/following",
				inbox: "#{full_url}/letters/#{@username}/inbox",
				outbox: "#{full_url}/letters/#{@username}/outbox",
				featured: "#{full_url}/letters/#{@username}/featured",
				name: @name,
				preferredUsername: @preferredUsername,
				summary: @summary,
				url: @url,
				manuallyApprovesFollowers: false,
				discoverable: true,
				published: @published,
				publicKey: {
					id: "#{full_url}/letters/#{@username}#main-key",
					owner: "#{full_url}/letters/#{@username}",
					publicKeyPem: ENV['PUBLIC_KEY']
				},
				icon: {
					type: "Image",
					mediaType: "image/png",
					url: "#{full_url}#{ActionController::Base.helpers.asset_path(@icon)}"
				},
				attachment: @attachments,
				# image: { //Put a header here
				# 	type: "Image",
				# 	mediaType: "image/png",
				# 	url: ""
				# },
				# featuredTags: "",
			}
		end
	end
end