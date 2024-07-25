module Pub
	class OrderedCollection < BaseObject
		Type = "OrderedCollection"

		def initialize(id, items)
			@id = id
			@items = items
		end

		def id
			"#{full_url}/#{@id}"
		end

		def to_h
			{
				**super,
				totalItems: @items.count,
				orderedItems: @items
			}
		end
	end
end