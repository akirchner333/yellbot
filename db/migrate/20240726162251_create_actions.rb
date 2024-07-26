class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.integer :activity_type
      t.string :actor
      t.string :object
      t.timestamps
    end
  end
end
