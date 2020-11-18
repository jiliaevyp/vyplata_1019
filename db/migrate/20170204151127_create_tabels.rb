class CreateTabels < ActiveRecord::Migration
   def change
       create_table :tabels do |t|
         t.references :personal, index: true, foreign_key: true
         t.references :mond, index: true, foreign_key: true
         # ============ берутся из Personal
         t.string  :title
         t.string  :forname
         t.string  :fornametwo
         t.string  :kadr
         t.string  :email
         t.integer :num_otdel
         t.integer :tarifhour

         # ============ берутся из Mond
         t.integer :num_monat
         t.string  :yahre
         t.integer :tag
         t.integer :hour
         t.integer :kfoberhour
         t.integer :kfnalog                # может корректироваться бухгалтером
         t.integer :procentsocial

         #============ вводится отработанное время
         t.integer :tagemach, default:21                  #, presence: true
         t.integer :hourmach, default:168                 #, presence: true
         t.integer :oberhour, default:0                   #, presence: true
         t.integer :krankentage, default:0                #, presence: true
         t.integer :urlaub, default:0                     #, presence: true
         t.integer :reisetage, default:0                  #, presence: true

         t.decimal :hourgeld                               # hourmach * tarifhour
         t.decimal :reisegeld                             # reisetage * tarifhour * 8
         t.decimal :oberhourgeld                          # oberhour * tarifhour * kfoberhour
         t.decimal :oklad                                 # hourgeld + oberhourgeld
         t.decimal :proc_bonus                            # вводится в процентах
         t.integer :bonus                                 # oklad * proc_bonus/100
         t.integer :nadbavka                              # вводится надбавка руб
         t.decimal :summa                                 # oklad + bonus + nadbavka
         #================== вводят===============================
         t.integer :krankengeld
         t.integer :urlaubgeld
         t.integer :minus, default:0, presence: true   # вычеты
         t.string  :textminus                       # за что вычеты

         t.decimal :gehalt                                 # summa + urlaubgeld + krankengeld + reisegeld - minus
         # ===================вычисление налога и з/платы на руки
         t.decimal :nalog, precision: 8, scale: 2
         t.decimal :naruki, precision: 8, scale: 2
         t.decimal :social, precision: 8, scale: 2
         t.decimal :vsego, precision: 8, scale: 2
         t.integer :close_update_tabel
                                            #флаг защиты на внесение изменения в записи по
                                            # рабочему месяцу & году "0" - запрещено
         t.string  :reservstring           #резерв
         t.integer :reservint              #резерв
         t.timestamps null: false
       end
   end
end
