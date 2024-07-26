module Pub
	class Accept < BaseObject
		Type = "Accept"

		def initialize(action)
			@action = action
		end

		def id
			"#{full_url}/actions/#{@action.id}"
		end

		def to_h
			{
				**super,
			    actor: @action.actor,
			    object: JSON.parse(@action.object),
			}
		end
	end
end