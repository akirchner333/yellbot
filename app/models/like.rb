class Like < ApplicationRecord
	belongs_to :note

	def create_from_activity(activity)
		note_id = activity.match(/notes\/(\d*)$/)[1].to_i
		create(
			actor: activity['actor']
			note_id: note_id
		)
	end
end
