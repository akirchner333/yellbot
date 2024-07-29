module Pub
	class Note < BaseObject
		Type = "Note"

		def self.rand(letter)
			new(Yell.yell(letter), letter, letter, DateTime.now)
		end

		def self.from_model(note)
			new(note.content, note.letter, note.id, note.created_at)
		end

		def initialize(post, actor, note_id, published)
			@words = post
			@actor = actor
			@note_id = note_id
			@published = published
		end

		# TODO: Figure out the id for these posts
		# They don't actually exist as posts in the database, not necessarily
		def id
			"#{full_url}/notes/#{@note_id}"
		end

		def content
			<<~HTML
				<p>
					#{@words}
				</p>
			HTML
			.gsub(/[\t\n]/, "")
		end

		def to_h
			{
				**super,
				published: @published.iso8601,
				summary: nil,
				url: "#{full_url}/notes/#{@note_id}",
				attributedTo:"#{full_url}/letters/#{@actor}",
				to:[
					"https://www.w3.org/ns/activitystreams#Public"
				],
				cc:[
					"#{full_url}/letters/#{@actor}/collections/followers"
				],
				sensitive: false,
				localOnly: false,
				content: content,
				contentMap: {
					en: content
				},
				attachment: [],
				tag: [],
				# inReplyTo: @post.parent_id ? "#{full_url}/posts/#{@post.parent_id}.json" : nil,
				inReplyTo: nil,
				# on Mastodon this links to a collection of replies. But see if direct links work
				# replies: @post.replies.pluck(:id).map { |id| "#{full_url}/posts/#{id}.json" }
				replies: nil,
				#atomUri: "...",
				inReplyToAtomUri: nil,
				#conversation: "tag:#{ENV['url']},#{post.created_at}:objectId=#{post.id}:objectType=Conversation",
			}
		end
	end
end