class CreateInvoices < ActiveRecord::Migration
  def up
    create_table :invoices do |t|
      t.timestamps
      t.integer :client_id, null: false
      t.string :number, null: false
      t.date :date, null: false
      t.decimal :amount, null: false, default: 0
      t.text :note
    end
  end

  def down
    drop_table :invoices
  end
end
