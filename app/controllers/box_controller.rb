class BoxController < ApplicationController
	include ActivityPubHelper

	skip_before_action :verify_authenticity_token

	def in
		body = JSON.parse(request.raw_post)
			
		if helpers.sig_check(request.headers)
			if body['type'] == "Follow"
				follow = Follow.create_from_activity(body)
				if follow.valid?
					action = Action.create(
						activity_type: "accept",
						actor: "#{full_url}/letters/#{follow.letter}",
						object: JSON.generate(body)
					)
					activity_post(follow.inbox, action.to_activity.to_s, follow.letter)
				end
			elsif body['type'] == "Undo"
				if body['object']['type'] == 'Follow'
					Follow
						.find_by_activity(body['actor'], body['object']['object'])
						.delete_all
				end
			end

			render plain: 'OK', status: 200
		else
			render plain: 'Request signature could not be verified', status: 401
		end
	end

	private
end
