class ChangeColumnDefaultUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :oauth_default, false
  end
end
