class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.references :personal, index: true, foreign_key: true
      t.string  :email
      t.string  :password_hash
      t.string  :password_salt
      t.string  :password, presence: true, length:  {minimum: 3}
      t.string  :password_confirmation, presence: true, length:  {minimum: 3}
      t.integer :glob_admin, :default => "0"
      t.timestamps null: false
    end
  end
end
