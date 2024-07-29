class AddNoteReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :reply_actor, :string
    add_column :notes, :reply_note, :string
  end
end
