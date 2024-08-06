require 'rails_helper'

RSpec.describe Follow, type: :model do
  context 'create_from_activity' do
    let(:activity) {{
      "@context" => "https://www.w3.org/ns/activitystreams",
      "id" => "https://example.com/1234",
      "type" => "Follow",
      "actor" => "https://example.com/users/example_actor",
      "object" => "https://aaaa.rest/letters/5"
    }}

    # Gotta ignore this until I set up some kind of http handling
    it 'creates a new follow' do
      stub_request(:get, "https://example.com/users/example_actor").
        to_return(body: file_fixture("actor.json").read)

      expect do
        follow = Follow.create_from_activity(activity)
        expect(follow.letter).to eql("5")
        expect(follow.host).to eql("example.com")
        expect(follow.username).to eql("example_actor")
        expect(follow.url_id).to eql("https://example.com/users/example_actor")
        expect(follow.shared_inbox).to eql("https://example.com/inbox")
        expect(follow.inbox).to eql("https://example.com/users/example_actor/inbox")
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

  context 'Move' do
    let(:activity) {{
      "@context" => "https://www.w3.org/ns/activitystreams",
      "id" => "https://prevexample.com/users/example_actor#moves/1",
      "actor" => "https://prevexample.com/users/example_actor",
      "type" => "Move",
      "object" => "https://prevexample.com/users/example_actor",
      "target" => "https://example.com/users/example_actor",
      "to" => "https://prevexample.com/users/example_actor/followers"
    }}

    it 'updates follows' do
      follow = create :follow,
        url_id: "https://prevexample.com/users/example_actor",
        letter: "b"
      follow_two = create :follow,
        url_id: "https://prevexample.com/users/example_actor",
        letter: "5" 

      stub_request(:get, "https://example.com/users/example_actor").
        to_return(body: file_fixture("actor.json").read)

      Follow.move(activity)

      expect(Follow.count).to be(2)
      follow = Follow.find(follow.id)
      expect(follow.letter).to eql("b")
      expect(follow.url_id).to eql("https://example.com/users/example_actor")

      follow_two = Follow.find(follow_two.id)
      expect(follow_two.letter).to eql("5")
      expect(follow_two.url_id).to eql("https://example.com/users/example_actor")
    end
  end

  context 'letter_from_url' do
    it 'handles basic letters' do
      expect(Follow.letter_from_url("localhost:3000/letters/a")).to eql("a")
    end

    it 'handles unicode letters' do
      expect(Follow.letter_from_url("localhost:3000/letters/00025")).to eql("%")
    end
  end
end
