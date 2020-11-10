class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.references :admin, index: true, foreign_key: true
      t.string    :access_controller
      t.string    :access_action
      t.string    :format
      t.string    :format_next
      t.integer   :access_all_otdel      # 0 - denied, 1 - access
      t.integer   :access_full        # 0 - denied, 1 - access
      t.integer   :access_index       # 0 - denied, 1 - access
      t.integer   :access_show       # 0 - denied, 1 - access
      t.integer   :access_edit      # 0 - denied, 1 - access
      t.integer   :access_new      # 0 - denied, 1 - access
      t.integer   :access_del       # 0 - denied, 1 - access
      t.integer   :access_print      # 0 - denied, 1 - access
      t.integer   :access_email       # 0 - denied, 1 - access

      t.timestamps null: false
    end
  end
end
