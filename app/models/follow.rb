class Follow < ApplicationRecord
	def inbox
		url_id + "/inbox"
	end
end
