class AddDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :string, default: ""
  end
end
