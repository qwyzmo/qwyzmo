class AddPasswordResetToken < ActiveRecord::Migration
  def change
  	add_column :users, :password_reset_token, :string
  	add_index  :users, :password_reset_token
  	add_column :users, :password_reset_token_date, :datetime
  end
end
