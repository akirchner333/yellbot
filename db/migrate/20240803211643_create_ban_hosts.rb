class CreateBanHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :ban_hosts do |t|
      t.string :name
      t.timestamps
    end
  end
end
