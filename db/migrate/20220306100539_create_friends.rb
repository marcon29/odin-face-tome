class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.references :request_sender, foreign_key: {to_table: :users}
      t.references :request_receiver, foreign_key: {to_table: :users}
      t.string :request_status, default: "pending"

      t.timestamps
    end
  end
end
