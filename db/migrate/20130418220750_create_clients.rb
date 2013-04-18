class CreateClients < ActiveRecord::Migration
  def up
    create_table :clients do |t|
      t.timestamps
      t.string :name, null: false
      t.text :address
      t.string :iva
      t.string :cf
      t.string :payment_type
      t.string :bank
      t.string :abi
      t.string :cab
      t.decimal :hourly_cost
      t.text :note
    end
  end

  def down
    drop_table :clients
  end
end
