module Pub
	class OrderedCollectionRoot < BaseObject
		Type = "OrderedCollection"

		def initialize(total, id)
			@total = total
			@id = id
		end

		def id
			"#{full_url}/#{@id}"
		end

		def to_h
			{
				**super,
				totalItems: @total,
				first: "#{id}?page=1"
			}
		end
	end
end