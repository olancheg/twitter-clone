class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.references :tweet
      t.references :user

      t.timestamps
    end
    add_index :comments, :tweet_id
    add_index :comments, :user_id
  end
end
