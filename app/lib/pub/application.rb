module Pub
	class Application < SecureObject
		Type = "Application"

		def initialize(letter)
			super()

			@letter = letter
			# Here are fields which might one day be set programatically
			# But for now are hardcoded (cause I only have one actor)
			@summary = <<~HTML
			<p>
				#{Yell.yell(letter)}
			</p>
			HTML
			.gsub(/[\t\n]/, "")
			@name = letter
			@username = letter
			@preferredUsername = letter
			@url = id
			# @icon = 'lazar_icon.png'
			@published = "1960-11-24T00:00:00Z"
			@attachments = [
				{
					type: "PropertyValue",
					name: "Posts every",
					value: "Two Hours"
				}
			]
		end

		def id
			"#{full_url}/letters/#{@letter}"
		end

		def to_h
			{
				**super,
				followers: "#{full_url}/letters/#{@username}/followers",
				following: "#{full_url}/letters/#{@username}/following",
				inbox: "#{full_url}/letters/inbox",
				outbox: "#{full_url}/letters/outbox",
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
					owner: "#{full_url}/letters/#{@username}#main-key",
					publicKeyPem: "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6EfbjygN0GF4pt4T09am\nv/cHt39xXNd0CRPA4f9uuX7iGqvNiq3OuGm3HUIDbUGhLQ3iid6v4A8EUu+ws7bD\nbnVdUtYr8MZT3qQC6ryvR42hvj1dNDPTkbQ+9f/BLeLKT7ux4abvusZld0TcMvCO\niC7av7PXQQ6bYS1MwJIBP4cfd+zi2jaKeGyStnWIdXHiFj1TYuC81BvgauW3SEdx\nZY3MSPYAGBTOAMrE81t+KJnBgVZkP9G/c+2LrPozkL9Xbov6O9xTCJtlknnCeIw1\npWTCb6Tl2FytrnvnkT9EWWRWV4RJDBxRaJWPOx7f6N5aQWCz/gbUyHDb2ZEnTzzM\niwIDAQAB\n-----END PUBLIC KEY-----"
				},
				# icon: {
				# 	type: "Image",
				# 	mediaType: "image/png",
				# 	url: "#{full_url}#{ActionController::Base.helpers.asset_path(@icon)}"
				# },
				attachment: @attachments,
				# following: "",
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