class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :name
      t.string :email
      t.string :content
      t.string :website, default: "#"
      t.references :article, index: true, foreign_key: true
      t.integer :parent, default: -1;

      t.timestamps null: false
    end
    add_index :comments, [:article_id, :created_at]
  end
end
