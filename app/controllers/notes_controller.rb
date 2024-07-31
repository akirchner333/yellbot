class NotesController < ApplicationController
	def show
		@note = Note.find(params[:id])
		respond_to do |format|
			format.html
			format.any(:json, :activity, :linked_data) { render json: Pub::Note.new(@note) }
		end
	end

	def replies
		id = "notes/#{params[:id]}/replies"
		collection = params[:page].nil? ? 
			Pub::OrderedCollectionRoot.new(0, id) :
			Pub::OrderedCollectionPage.new(0, id, params[:page].to_i, [])

		render :json => collection
	end
end
