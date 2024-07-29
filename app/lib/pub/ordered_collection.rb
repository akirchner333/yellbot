module Pub
	class OrderedCollection < BaseObject
		Type = "OrderedCollection"

		def self.from_model(id, query, params, method = :to_activity)
			total = query.count
			if(total <= 10)
				new(id, query.map { |r| r.send(method) })
			else
				if(params[:page].nil?)
					OrderedCollectionRoot.new(total, id)
				else
					page = params[:page].to_i
					OrderedCollectionPage.new(
						total,
						id,
						page,
						query.limit(10)
							.offset(10 * (page - 1))
							.map { |r| r.send(method) }
					)
				end
			end
		end

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