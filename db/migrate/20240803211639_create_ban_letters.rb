class CreateBanLetters < ActiveRecord::Migration[7.0]
  def change
    create_table :ban_letters do |t|
      t.string :letter
      t.timestamps
    end
  end
end
