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
      stub_request(:post, "https://example.com/users/example/inbox")
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
      expect(activity[:content]).to include("@example@example.com")
    end
  end

  context 'reply' do
    before do
      stub_request(:post, "https://example.com/users/actor/inbox")
    end

    let!(:note) { create :note, id: 1 }

    it 'creates a reply' do
      activity = JSON.parse(file_fixture("reply.json").read)
      expect {
        note = Note.reply(activity)
        expect(note.reply_note).to eql("https://example.com/users/actor/statuses/1")
        expect(note.reply_actor).to eql("https://example.com/users/actor")
      }.to change { Note.count }.by(1)
    end

    it 'does not reply to messages from banned hosts' do
      create :ban_host, name: "example.com"

      activity = JSON.parse(file_fixture("reply.json").read)
      expect {
        expect(Note.reply(activity)).to be_nil
      }.not_to change { Note.count }
    end

    it 'does not reply if there was a recent reply' do
      create :note, content: "blub", created_at: 20.minutes.ago, reply_actor: "https://example.com/users/actor"
      create :note, content: "blub", created_at: 5.minutes.ago, reply_actor: "https://example.com/users/actor"
      activity = JSON.parse(file_fixture("reply.json").read)
      expect {
        expect(Note.reply(activity)).to be_nil
      }.not_to change { Note.count }
    end
  end
end
