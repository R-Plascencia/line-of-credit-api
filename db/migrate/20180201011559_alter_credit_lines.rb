class AlterCreditLines < ActiveRecord::Migration[5.1]
  def change
    puts 'Adding column for interest to Credit Lines for running interest amt'
    add_column('credit_lines', 'interest', :float, :default => 0.0)
  end
end
