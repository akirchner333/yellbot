class LettersController < ApplicationController
	def show
		@letter = params[:id]
		@notes = Note.where(letter: @letter).limit(10)

		respond_to do |format|
			format.html
			format.any(:json, :activity, :linked_data) { render json: Pub::Service.new(@letter).to_h }
		end
	end

	def search
		letter = params[:query][0]

		redirect_to "/letters/#{letter}"
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
		render :json => Pub::OrderedCollection.from_model(
			"letters/#{params[:id]}/followers",
			Follow.where(letter: params[:id]),
			params,
			:url_id
		)
	end

	def following
		id = "letters/#{params[:id]}/following"
		collection = params[:page].nil? ? 
			Pub::OrderedCollectionRoot.new(0, id) :
			Pub::OrderedCollectionPage.new(0, id, params[:page].to_i, [])

		render :json => collection
	end
end
