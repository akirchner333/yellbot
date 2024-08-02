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
end
