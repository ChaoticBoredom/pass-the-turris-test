class SessionStore < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :guid, :null => false
      t.timestamp :expiry_at, :null => false
      t.string :refresh_token, :null => false

      t.timestamps :null => false
    end
  end
end
