class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.timestamps
      t.string :username, null: false
      t.string :password_hash, null: false
      t.string :password_salt, null: false
    end
  end

  def down
    drop_table :users
  end
end
