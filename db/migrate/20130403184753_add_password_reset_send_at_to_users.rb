class AddPasswordResetSendAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_send_at, :datetime
  end
end
