class Action < ApplicationRecord
	enum activity_type: %i[accept undo]

	def to_activity
		if activity_type == "accept"
			return Pub::Accept.new(self)
		end
	end
end
