class NodeInfoController < ApplicationController
	include ActivityPubHelper

	def twozero
		render :json => {
			version: "2.0",
			software: software,
			protocols: ["activitypub"],
			services: services,
			openRegistrations: false,
			usage: usage,
			metadata: metadata
		}
	end

	def twoone
		render :json => {
			version: "2.1",
			software: {
				**software,
				repository: "https://github.com/akirchner333/yellbot",
				homepage: "https://yellbot.online/"
			},
			protocols: ["activitypub"],
			services: services,
			openRegistrations: false,
			usage: usage,
			metadata: metadata
		}
	end

	private
	def software
		{
			name: "Yellbot",
			version: "1.0"
		}
	end

	def services
		# No services
		{
			inbound: [],
			outbound: []
		}
	end

	def usage
		activeUsers = Follow.select(:letter).uniq.count

		{
			users: {
				total: 1114112,
				activateHalfyear: activeUsers,
				activeMonth: activeUsers
			},
			localPosts: Note.count
		}
	end

	def metadata
		{
			nodeName: "yellbot.online",
			nodeDescription: "A bot that yells for every unicode character."
		}
	end
end