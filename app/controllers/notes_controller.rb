class NotesController < ApplicationController
	def show
		@note = Note.find(params[:id])
		respond_to do |format|
			format.html
			format.any(:json, :activity, :linked_data) { render json: Pub::Note.new(@note) }
		end
	end
end
