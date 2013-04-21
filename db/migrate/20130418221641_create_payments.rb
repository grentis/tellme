class CreatePayments < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.timestamps
      t.integer :invoice_id, null: false
      t.decimal :value, null: false
      t.integer :year, null: false
      t.integer :month, null: false
      t.boolean :paid, null: false, default: false
      t.text :note
    end
  end

  def down
    drop_table :payments
  end
end
