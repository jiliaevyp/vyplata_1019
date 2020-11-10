class Tabel < ActiveRecord::Base

  belongs_to  :mond     #has_many
  belongs_to  :personal #has_many
  has_many    :comments, :dependent => :delete_all


end
