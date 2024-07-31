class Like < ApplicationRecord
	belongs_to :note

	def self.create_from_activity(activity)
		note_id = activity["object"].match(/notes\/(\d*)$/)[1].to_i
		create(
			actor: activity['actor'],
			note_id: note_id
		)
	end
end
