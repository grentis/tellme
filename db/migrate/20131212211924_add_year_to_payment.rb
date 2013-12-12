class AddYearToPayment < ActiveRecord::Migration
  def up
    change_table :invoices do |t|
      t.integer :year, null: false, default: Date.today.year
    end
    Invoice.all.each do |i|
      i.year = i.date.year
      i.save
    end
    change_column_default(:invoices, :year, nil)
  end

  def down
    remove_column :invoices, :year
  end
end
