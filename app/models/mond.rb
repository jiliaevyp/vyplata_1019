class Mond < ActiveRecord::Base

  has_many  :comments,  :dependent => :delete_all
  has_many  :tabels,    :dependent => :delete_all

  #$mond_update = 0      # изменение записей Mond запрещено для разрешения установить в "1"
  $monds = [['январь',0],['февраль',1], ['март',2], ['апрель',3], ['май',4], ['июнь',5],
            ['июль',6], ['август',7], ['сентябрь',8], ['октябрь',9], ['ноябрь',10], ['декабрь',11]]

  $monat_array = ['январь', 'февраль', 'март', 'апрель', 'май', 'июнь',
                  'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь']
  $base_block = [['Блокировать',1], ['Разблокировать', 0]]


  #validates :yahre, presence: true
  validates :tag, :hour, :kfoberhour, :kfnalog, :procentsocial, presence: true #:num_monat,
  #validates :yahre, numericality: {greater_than_or_equal_to: 2020}, presence: true
  validates :hour, numericality: {greater_than_or_equal_to: 0}
  validates :hour, numericality: {less_than_or_equal_to:176}

  validates :kfoberhour, numericality: {greater_than_or_equal_to: 0}
  validates :kfoberhour, numericality: {less_than_or_equal_to:2}

  validates :kfnalog, numericality: {greater_than_or_equal_to: 0}
  validates :kfnalog, numericality: {less_than_or_equal_to:30}

  validates :procentsocial, numericality: {greater_than_or_equal_to: 0}
  validates :procentsocial, numericality: {less_than_or_equal_to:30}
end
