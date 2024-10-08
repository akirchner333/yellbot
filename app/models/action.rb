class Action < ApplicationRecord
	enum activity_type: %i[accept undo create_note]

	def to_activity()
		if activity_type == "accept"
			return Pub::Accept.new(self)
		elsif activity_type == "create_note"
			return Pub::Create.new(self)
		end
	end
end
