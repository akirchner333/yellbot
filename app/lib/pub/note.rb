module Pub
	class Note < BaseObject
		Type = "Note"

		def initialize(note)
			@words = note.content
			@actor = note.letter
			@note_id = note.id
			@published = note.created_at
			@reply_to = note.reply_note
			@reply_actor = note.reply_actor
		end

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
					"#{full_url}/letters/#{@actor}/followers",
					@reply_actor
				].compact,
				sensitive: false,
				localOnly: false,
				content: "#{content}",
				contentMap: {
					en: content
				},
				attachment: [],
				tag: tag,
				inReplyTo: @reply_to,
				# on Mastodon this links to a collection of replies. But see if direct links work
				# replies: @post.replies.pluck(:id).map { |id| "#{full_url}/posts/#{id}.json" }
				replies: nil,
				#atomUri: "...",
				inReplyToAtomUri: @reply_to,
				#conversation: "tag:#{ENV['url']},#{post.created_at}:objectId=#{post.id}:objectType=Conversation",
			}
		end

		def tag
			if @reply_actor.nil?
				[]
			else
				uri = URI.parse(@reply_actor)
				[{
					type: "Mention",
					href: @reply_actor,
					name: "@#{@reply_actor.split("/").last}@#{uri.host}"
				}]
			end
		end
	end
end