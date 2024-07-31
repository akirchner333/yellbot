require 'rails_helper'

RSpec.describe Like, type: :model do
  context 'create_from_activity' do
    let(:note) { create :note }

    it 'creates a like' do
      activity = {
        "@context" => "https://www.w3.org/ns/activitystreams",
        "id" => "https://activitypub.academy/users/babeta_zondaist#likes/582",
        "type" => "Like",
        "actor" => "https://activitypub.academy/users/babeta_zondaist",
        "object" => "https://localhost:300/notes/#{note.id}"
      }

      like = Like.create_from_activity(activity)
      expect(like.actor).to eql("https://activitypub.academy/users/babeta_zondaist")
      expect(like.note_id).to be(note.id)
      expect(Like.count).to be(1)
    end
  end
end
