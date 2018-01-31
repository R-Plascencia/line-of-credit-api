class CreateWithdrawals < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawals do |t|
      t.references :credit_line, foreign_key: true
      t.float :amount, :null => false
      t.float :new_bal

      t.timestamps
    end
  end
end
