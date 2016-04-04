class AddAuthorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :author, :boolean, default: true
  end
end
