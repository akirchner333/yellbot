class Like < ApplicationRecord
	belongs_to :note

	def self.create_from_activity(activity)
		note_id = get_id_from_url(activity["object"])
		create(
			actor: activity['actor'],
			note_id: note_id
		)
	end

	def self.delete_from_activity(activity)
		where(
			note_id: get_id_from_url(activity['object']['object']),
			actor: activity['object']['actor']
		).delete_all
	end

	def self.get_id_from_url(url)
		url.match(/notes\/(\d*)$/)[1].to_i
	end
end
