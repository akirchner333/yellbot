class LettersController < ApplicationController
	def show
		@letter = params[:id]

		respond_to do |format|
			format.html
			format.any(:json, :activity, :linked_data) { render json: Pub::Application.new(@letter).to_h }
		end
	end

	def featured
		letter = params[:id]
		if Note.where(letter: letter).count < 5
			5.times do
				Note.generate(letter)
			end
		end

		collection = Pub::OrderedCollection.new(
			"letters/#{letter}/featured",
			Note.where(letter: letter).limit(5).order(created_at: :desc).map { |n| n.to_activity }
		)

		render :json => collection
	end

	def followers
		# Now, in this case there will actually be somebody following something
		# So we actually have to, ya known, interact with the database
		total = Follow.where(letter: params[:id]).count
		id = "letters/#{params[:id]}/followers"
		if total <= 10
			collection = Pub::OrderedCollection.new(
				id,
				Follow.where(letter: params[:id]).pluck(:url_id)
			)

			render :json => collection
		else
			if(params[:page].nil?)
				collection = Pub::OrderedCollectionRoot.new(total, id)
				render :json => collection
			else
				collection = Pub::OrderedCollectionPage.new(
					total,
					id,
					params[:page].to_i,
					Follow
						.limit(10)
						.offset(10 * (params[:page].to_i - 1))
						.pluck(:url_id)
				)
				render :json => collection
			end
		end
	end

	def following
		id = "letters/#{params[:id]}/following"
		collection = params[:page].nil? ? 
			Pub::OrderedCollectionRoot.new(0, id) :
			Pub::OrderedCollectionPage.new(0, id, params[:page].to_i, [])

		render :json => collection.to_h
	end

	def outbox
		total = Note.where(letter: params[:id]).count
		id = "letters/#{params[:id]}/outbox"
		if total <= 10
			collection = Pub::OrderedCollection.new(
				id,
				Note.where(letter: params[:id])
					.order(created_at: :desc)
					.all
					.map { |n| n.to_activity }
			)

			render :json => collection
		else
			if(params[:page].nil?)
				collection = Pub::OrderedCollectionRoot.new(total, id)
				render :json => collection
			else
				collection = Pub::OrderedCollectionPage.new(
					total,
					id,
					params[:page].to_i,
					Note.where(letter: params[:id])
						.order(created_at: :desc)
						.limit(10)
						.offset(10 * (params[:page].to_i - 1))
						.map { |p| p.create_object }
				)
				render :json => collection
			end
		end
	end
end
