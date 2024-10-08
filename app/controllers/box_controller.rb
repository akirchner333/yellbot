class BoxController < ApplicationController
	include ActivityPubHelper

	skip_before_action :verify_authenticity_token

	def in
		body = JSON.parse(request.raw_post)
		Rails.logger.info("inbox body #{body}")
		if helpers.sig_check(request.headers)
			if body['type'] == "Follow"
				follow = Follow.create_from_activity(body)
				if follow.valid?
					action = Action.create(
						activity_type: "accept",
						actor: "#{full_url}/letters/#{follow.handle}",
						object: JSON.generate(body)
					)
					activity_post(follow.inbox, action.to_activity.to_s, follow.handle)
				end
			elsif body['type'] == "Like"
				Like.create_from_activity(body)
			elsif body['type'] == "Create"
				Note.reply(body)
			elsif body['type'] == "Move"
				Follow.move(body)
			elsif body['type'] == "Undo"
				if body['object']['type'] == 'Follow'
					Follow
						.find_by_activity(body['actor'], body['object']['object'])
						.delete_all
				elsif body['object']['type'] == 'Like'
					Like.delete_from_activity(body)
				end
			end

			render plain: 'OK', status: 200
		else
			render plain: 'Request signature could not be verified', status: 401
		end
	end

	def outbox
		total = Note.where(letter: LetterHandler.get_letter(params[:id])).count
		id = "letters/#{params[:id]}/outbox"

		render :json => Pub::OrderedCollection.from_model(
			id,
			Note.where(letter: params[:id]).order(created_at: :desc),
			params
		)
	end

	private
end
