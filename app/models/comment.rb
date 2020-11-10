class Comment < ActiveRecord::Base

  $commenter_pasw = ['1', '2', '3', '4', '5', '6']
  $commenter = ['Ермолаев','Жиляев','Карпова','Лазарева','Шапошников']

  belongs_to  :personal    #has_many
  belongs_to  :mond        #has_many
  belongs_to  :tabel   #has_many

  #validates :commenter, presence: true, length:  {minimum: 4}
  validates :body, presence: true
end
