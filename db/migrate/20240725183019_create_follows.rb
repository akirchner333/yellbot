class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.string :letter
      t.string :host
      t.string :username
      t.string :url_id
      t.timestamps
    end
  end
end
