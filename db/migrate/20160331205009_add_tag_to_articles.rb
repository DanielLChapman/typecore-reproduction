class AddTagToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :tag, :string, default: ""
  end
end
