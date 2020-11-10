class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :mond, index: true, foreign_key: true
      t.references :personal, index: true, foreign_key: true
      t.references :tabel, index: true, foreign_key: true
      #============= из Personal ===============
      t.string  :title
      t.string  :email
      #============= вводятся здесь ===============
      t.integer :commenter_id
      t.string  :commenter_title
      t.text    :body
      t.integer :plunus, default: 0
      t.date    :data

      t.integer :close_update     #флаг защиты на внесение изменения "0" - запрещено
      t.string  :reservstring     #резерв
      t.integer :reservint        #резерв

      t.timestamps
    end
  end
end
