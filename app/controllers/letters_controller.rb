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
		collection = Pub::OrderedCollection.new(
			"letters/#{letter}/collections/featured",
			Array.new(5) { Pub::Note.rand(letter).to_h}
		)

		render :json => collection
	end

	def followers
		# Now, in this case there will actually be somebody following something
		# So we actually have to, ya known, interact with the database
		id = "letters/#{params[:id]}/followers"
		collection = params[:page].nil? ? 
			Pub::OrderedCollectionRoot.new(0, id) :
			Pub::OrderedCollectionPage.new(0, id, params[:page].to_i, [])

		render :json => collection.to_h
	end

	def following
		id = "letters/#{params[:id]}/following"
		collection = params[:page].nil? ? 
			Pub::OrderedCollectionRoot.new(0, id) :
			Pub::OrderedCollectionPage.new(0, id, params[:page].to_i, [])

		render :json => collection.to_h
	end
end
