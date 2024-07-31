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
				summary: nil,
				inReplyTo: @reply_to,
				published: @published.iso8601,
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
				inReplyToAtomUri: @reply_to,
				localOnly: false,
				content: content,
				contentMap: {
					en: content
				},
				attachment: [],
				tag: tag,
				# This is a placeholder and a lie -
				# I'm not meaningfully tracking replies
				replies: {
					id:"#{id}/replies",
					type:"Collection",
					first:{
						type:"CollectionPage",
						next: "#{id}/replies?page=1",
						partOf: "#{id}/replies",
						items: []
					}
				}
				#atomUri: "...",
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