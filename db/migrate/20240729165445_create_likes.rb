class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.string :actor
      t.belongs_to :note
      t.timestamps
    end
  end
end
