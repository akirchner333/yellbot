require 'rails_helper'

RSpec.describe Follow, type: :model do
  context 'create_from_activity' do
    let(:activity) {{
      "@context" => "https://www.w3.org/ns/activitystreams",
      "id" => "https://activitypub.academy/8b304755-d70a-4da3-ad58-07dccd2c28ee",
      "type" => "Follow",
      "actor" => "https://activitypub.academy/users/abilus_grabrad",
      "object" => "https://aaaa.rest/letters/5"
    }}

    # Gotta ignore this until I set up some kind of http handling
    xit 'creates a new follow' do
      expect do
        follow = Follow.create_from_activity(activity)
        expect(follow.letter).to eql("5")
        expect(follow.host).to eql("activitypub.academy")
        expect(follow.username).to eql("abilus_grabrad")
        expect(follow.url_id).to eql("https://activitypub.academy/users/abilus_grabrad")
      end.to change { Follow.count }.by(1)
    end
  end

  context 'allowed_host' do
    it 'does not allow hosts on the ban list' do
      create :ban_host, name: "example-host.com"

      follow = Follow.new(
        url_id: "https://example-host.com/actors/follow",
        host: "example-host.com",
        username: "follow",
        letter: "t",
        inbox: "https://example-host.com/actors/follow/inbox",
        shared_inbox: "https://example-host.com/inbox"
      )

      expect(follow.valid?).to be_falsey
      expect(follow.errors[:host][0]).to eql("is not allowed by this instance.")
    end
  end
end
