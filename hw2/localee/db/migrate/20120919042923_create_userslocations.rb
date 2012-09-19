class CreateUserslocations < ActiveRecord::Migration
  def change
    create_table :userslocations do |t|
      t.integer :users_id
      t.integer :locations_id
    end
  end
end
