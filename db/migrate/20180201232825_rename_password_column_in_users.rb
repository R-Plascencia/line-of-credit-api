class RenamePasswordColumnInUsers < ActiveRecord::Migration[5.1]
  def change
    # Change for JWT use
    rename_column('users', 'password', 'password_digest')
  end
end
