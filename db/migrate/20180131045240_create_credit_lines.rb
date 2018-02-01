class CreateCreditLines < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_lines do |t|
      t.integer :user_id
      t.integer :credit_limit, :null => false
      t.float :principal_bal, :default => 0
      t.float :apr, :null => false

      t.boolean :maxed, :default => false

      t.string :name, :null => false, :limit => 40

      t.timestamps
    end
    add_index('credit_lines', 'user_id')
  end
end
