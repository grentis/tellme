class ChangeDefaultDateToPayment < ActiveRecord::Migration
  def up
    change_column_default(:payments, :date, nil)
  end

  def down
  end
end
