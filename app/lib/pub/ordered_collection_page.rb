module Pub
	class OrderedCollectionPage < BaseObject
		Type = "OrderedCollectionPage"
		Count = 10

		def initialize(total, id, page, items)
			@total = total
			@id = id
			@page = page
			@items = items
		end

		def id
			"#{parent_collection}?page=#{@page}"
		end

		def parent_collection
			"#{full_url}/#{@id}"
		end

		def to_h
			page = {
				**super,
				totalItems: @total,
				orderedItems: @items,
				partOf: parent_collection
			}

			page[:next] = "#{parent_collection}?page=#{@page + 1}" if @page * Count < @total
			page[:prev] = "#{parent_collection}?page=#{@page - 1}" if @page > 1

			page
		end
	end
end