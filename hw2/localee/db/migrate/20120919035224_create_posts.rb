class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :users_id
      t.integer :locations_id
      t.timestamps
    end
  end
end
