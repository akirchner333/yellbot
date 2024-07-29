require 'rails_helper'

RSpec.describe Action, type: :model do
  context 'to_activity' do
    it 'creates a create activitystream' do
      note = create :note, letter: "m"

      action = create :action, activity_type: 'create_note', object: note.to_activity.to_s

      object = action.to_activity.to_h

      expect(object[:cc].count).to be(1)
      expect(object[:actor]).to eql("https://localhost:3000/letters/m")
    end
  end
end
