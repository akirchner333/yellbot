class NotesController < ApplicationController
	def show
		@note = Note.find(params[:id])
		respond_to do |format|
			format.html
			format.all { render json: Pub::Note.from_model(@note) }
		end
	end

	def rand
		@letter = params[:id]

		respond_to do |format|
			format.html
			format.all { render json: Pub::Note.rand(@letter) }
		end
	end
end
