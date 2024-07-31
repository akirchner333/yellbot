require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'to_activity' do
    let(:note) { create :note, content: "aaa", letter: "a" }

    it 'creates a note' do
      activity = note.to_activity.to_h
      expect(activity[:id]).to eql("https://localhost:3000/notes/#{note.id}")
      expect(activity[:cc].count).to be(1)
      expect(activity[:tag]).to eql([])
    end

    it 'handles replies' do
      note = create :note, 
        content: "aaaa",
        letter: "a",
        reply_actor: "https://example.com/users/example",
        reply_note: "example.com"
      
      activity = note.to_activity.to_h
      expect(activity[:id]).to eql("https://localhost:3000/notes/#{note.id}")
      expect(activity[:cc].count).to be(2)
      expect(activity[:cc][1]).to eql("https://example.com/users/example")
      expect(activity[:inReplyTo]).to eql("example.com")
      expect(activity[:tag]).to eql([
        {
          type: "Mention",
          href: "https://example.com/users/example",
          name: "@example@example.com"
        }
      ])
    end
  end

  context 'reply' do
    it 'creates a reply' do
      note = create :note
      activity = {
        "@context" => [
          "https://www.w3.org/ns/activitystreams",
        ],
        "id" => "https://example.com/users/actor/statuses/1/activity",
        "type" => "Create",
        "actor" => "https://example.com/users/actor",
        "published" => "2024-07-31T21:13:41Z",
        "to" => [
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "cc" => [
          "https://example.com/users/actor/followers",
          "https://localhost:300/letters/b"
        ],
        "object" => {
          "id" => "https://example.com/users/actor/statuses/1",
          "type" => "Note",
          "summary" => nil,
          "inReplyTo" => "https://localhost:3000/notes/#{note.id}",
          "published" => "2024-07-31T21:13:41Z",
          "url" => "https://example.com/@actor/1",
          "attributedTo" => "https://example.com/users/actor",
          "to" => [
            "https://www.w3.org/ns/activitystreams#Public"
          ],
          "cc" => [
            "https://example.com/users/actor/followers",
            "https://localhost:300/letters/b"
          ],
          "sensitive" => false,
          "atomUri" => "https://example.com/users/actor/statuses/1",
          "inReplyToAtomUri" => "https://localhost:3000/notes/#{note.id}",
          "conversation" => "tag:instance.digital,2024-07-30:objectId=146921:objectType=Conversation",
          "content" => "<p>hi :)</p>",
          "contentMap" => {
            "en" => "<p>hi :)</p>"
          },
          "attachment" => [],
          "tag" => [],
          "replies" => {},
        },
        "signature" => {
          "type" => "RsaSignature2017",
          "creator" => "https://example.com/users/actor#main-key",
          "created" => "2024-07-31T21:13:42Z",
          "signatureValue" => "EBrWYB6EWVe5TbxSWDSk7x8EFxAdm2LtddQG2pdZDnXhyBxdBMcVhj5+2iYVSXAdmSopX00OfkvtTkfWJWkWqTgko23Hns9Z25Lj3Zld00ntWEym0ZUtgbJzCILOF+qMN1JN5rIMI+rgblS/gFDbAePxACIJuNsX2Ge4+ZQLAXjKKlVODTWvY6wNUjw0iVoXsEVj6SqQgpM8Es72S3T0BGz1J4ggyw5UW/LtH1mbZ15pQ3vUx0sbViccZu25gRsdJ2JYVxQNvq//1jtSpQ2p1rtaMq98+HfZxX9vpy5BVbmAlKtTPMbbXRh/MlVB9soyxjFj2FkYy+WkupKiAE5I1w=="
        }
      }

      expect {
        note = Note.reply(activity)
        expect(note.reply_note).to eql("https://example.com/users/actor/statuses/1")
        expect(note.reply_actor).to eql("https://example.com/users/actor")
      }.to change { Note.count }.by(1)
      
    end
  end
end
