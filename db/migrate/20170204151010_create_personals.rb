class CreatePersonals < ActiveRecord::Migration
  def change
    create_table :personals do |t|
      t.string  :title
      t.string  :forname
      t.string  :fornametwo
      t.string  :image_url
      t.string  :kadr
      t.integer :num_otdel    # номер отдела
      t.string  :otdel
      t.integer :real
      t.integer :tarifhour
      t.date    :begdata
      t.date    :enddata
      t.string  :bilding
      t.date    :borndata
      t.string  :familie
      t.string  :kinder
      t.string  :haus
      t.string  :auto
      t.string  :address
      t.string  :realaddress
      t.string  :tel
      t.string  :email,      :default => ""

      t.string  :werte
      t.text    :information

      #========================= служебные
      t.integer :close_update      #флаг защиты на внесение изменения в записи "0" - запрещено
      t.string  :reservstring           #резерв
      t.integer :reservint              #резерв
      #доступ к базам
      t.integer :personal_admin,     :default => "0"
        #доступ к базам: доступа нет-0,'доступ разрешен - 1,

      t.string  :encrypted_password, :null => false, :default => ""
      t.string  :password_digest
      t.string  :password, :default => ""
      t.string  :open_password, :default => ""

      t.timestamps
    end
  end
end
