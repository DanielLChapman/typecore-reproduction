class AddPictureToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :picture, :string, default: "http://placehold.it/100x100"
  end
end
