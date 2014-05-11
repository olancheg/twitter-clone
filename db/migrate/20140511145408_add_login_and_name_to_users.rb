class AddLoginAndNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :realname, :string
  end
end
