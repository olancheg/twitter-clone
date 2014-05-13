class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.references :user
      t.references :target

      t.timestamps
    end
    add_index :bans, :user_id
    add_index :bans, :target_id
  end
end
