class AddInboxesToFollow < ActiveRecord::Migration[7.0]
  def change
    add_column :follows, :inbox, :string
    add_column :follows, :shared_inbox, :string
  end
end
