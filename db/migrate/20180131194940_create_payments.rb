class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.float :amount #, :null => false
      t.references :credit_line, foreign_key: true

      t.timestamps
    end
  end
end
