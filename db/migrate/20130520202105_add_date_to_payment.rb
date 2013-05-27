class AddDateToPayment < ActiveRecord::Migration
  def up
    change_table :payments do |t|
      t.date :date, null: false, default: Date.today
    end
    Payment.all.each do |p|
      p.date = Date.parse('1-' + p.month.to_s + '-' + p.year.to_s)
      p.save
    end
    remove_column :payments, :year
    remove_column :payments, :month
  end

  def down
    remove_column :payments, :date
  end
end
