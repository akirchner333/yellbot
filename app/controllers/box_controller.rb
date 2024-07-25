class BoxController < ApplicationController
	skip_before_action :verify_authenticity_token
	def in
		body = JSON.parse(request.raw_post)
			
		if helpers.sig_check(request.headers)
			if body['type'] == "Follow" && body['object'].ends_with?('lazar')
				follow = Follow.create_from_activity(body)
				accept = Pub::Accept.new(follow, body)

				activity_post(follw.inbox, accept.to_s)
			elsif body['type'] == "Undo"
				if body['object']['type'] == 'Follow'
					# Unfollow
					letter = body['object']['object']
						.match(/https:\/\/#{ENV['url']}\/letters\/(.)/)[1]
					Follow.where(url_id: body['actor'], letter: letter).delete_all
				end
			end

			render plain: 'OK', status: 200
		else
			render plain: 'Request signature could not be verified', status: 401
		end
	end

	def out
	end

	private
end
