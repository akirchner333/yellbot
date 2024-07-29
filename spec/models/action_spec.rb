require 'rails_helper'

RSpec.describe Action, type: :model do
  context 'to_activity' do
    it 'creates a create activity' do
      note = create :note

      action = create :action, activity_type: 'create_note'

      object = action.to_activity(note).to_h
      # binding.pry
      expect(object[:cc].count).to be(1)
      expect(object[:object]).to eql(note.to_activity.to_h)
    end
  end
end
