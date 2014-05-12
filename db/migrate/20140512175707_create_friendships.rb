class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :sender
      t.references :recipient

      t.timestamps
    end
    add_index :friendships, :sender_id
    add_index :friendships, :recipient_id
  end
end
