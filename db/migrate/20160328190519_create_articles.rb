class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.references :user, index: true, foreign_key: true
      t.string :category
      t.text :body

      t.timestamps null: false
    end
    add_index :articles, [:user_id, :created_at]
  end
end
