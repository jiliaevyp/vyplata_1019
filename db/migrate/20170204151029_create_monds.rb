class CreateMonds < ActiveRecord::Migration
   def change
      create_table :monds do |t|

        t.string  :yahre
        t.integer :num_monat
        t.integer :tag, default: 21
        t.integer :hour, default: 168
        t.decimal :kfoberhour, precision: 2, scale:1, default: 2
        t.integer :kfnalog, default: 13
        t.integer :procentsocial, default: 24
        t.integer :block_mond, default: 0           # если "1" - Mond - изменения запрещены
        t.integer :block_personal, default: 0       # если "1" - Personal - изменения запрещены
        t.integer :block_real_personal, default: 0  # если "1" - Personal.where(mond_id: @mond.id, real: "real") - изменения запрещены
        t.integer :block_comment, default: 0        # если "1" - Comment.where(mond_id: @mond.id) - изменения запрещены
        t.integer :block_timetabel, default: 0      # если "1" - Tabel.where(mond_id: @mond.id) && params[:format]== "time"- в табеле изменения запрещены
        t.integer :block_tabel, default: 0          # если "1" - Tabel.where(mond_id: @mond.id)&& params[:format]== "tabel"      - в начислении изменения запрещены
        t.integer :block_buchtabel, default: 0      # если "1" - Tabel.where(mond_id: @mond.id)&& params[:format]== "buchtabel"  - в ведомости изменения запрещены

        #========================= служебные
        t.integer :close_update, default: 0      #флаг защиты на внесение изменения в записи по рабочему месяцу & году "0" - запрещено
        t.string  :reservstring      #резерв
        t.integer :reservint         #резерв

        t.timestamps
      end
   end
end
