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
end
