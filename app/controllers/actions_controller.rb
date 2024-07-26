class ActionsController < ApplicationController
	def show
		@action = Action.find(params[:id])

		render json: @action.to_activity
	end
end
