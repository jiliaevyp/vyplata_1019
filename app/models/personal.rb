class Personal < ActiveRecord::Base

  has_many  :comments, :dependent => :delete_all
  has_many  :tabels, :dependent => :delete_all
  has_one   :admin, :dependent => :destroy

  $numotdel  = ['0','1','2','3','4']
  $otdel =    ['Адм','Бух','Ком','КО','ПО']
  $otdel_long = ['Административный','Бухгалтерский','Комммерческий','Конструкторский','Производственный']

  $person_otdel = [['Административный', 0],['Бухгалтерский', 1],['Комммерческий', 2], ['Конструкторский', 3],
                   ['Производственный', 4]]

  $kadr = ["инженер","техник","бухгалтер","менеджер","настройщик", "монтажник","вед.инженер","инж.конструктор",
           "кладовщик","уборщик","зам.директора","нач.отдела","гл.бухгалтер","директор"]
  $gendirector = $kadr.last

  $family =   ['нет сведений','женат','замужем','холост','незамужем','вдовец','вдова']
  $bilding =  ['нет сведений','среднее','высшее','уч.степень']
  $kinder =   ['нет сведений','есть до 18лет','есть','нет']
  $haus =     ['нет сведений','есть', 'нет']
  $real =     [0,1]     # 1 - включить в табель 0 - удалить
  $real_word = ['не в в штате','в штате']
  $real_option =[['включить в ведомость', 1], ['не включать в ведомость', 0]]
  $select_otdel = nil
  $admin_input  =[['Сотрудник', 0], ['Администратор', 1]]
  $administrator= ['Сотрудник','Администратор']
  $personal_admin = 1


  validates :title, :forname, presence: true, length:  {minimum: 3}
  validates :tel, presence: true, uniqueness:  {message:'Номер телефона уже использован!'}
  validates :tarifhour, numericality: {greater_than_or_equal_to: 10.0, message: 'Значение должно быть больше 10!'}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX , message: 'Адрес уже использован!'},
            uniqueness: {case_sensitive: false}

  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      message: 'URL должен указывать на формат GIF, JPG или PNG'
  }
end
