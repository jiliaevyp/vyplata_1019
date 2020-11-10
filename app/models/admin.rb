class Admin < ActiveRecord::Base

  has_many :levels, :dependent => :delete_all
  belongs_to :personal
  #$name_admin = ["Карпова","Жиляев","Ермолаев","Лазарева","Шапошников" ]

  validates_uniqueness_of :personal_id
  validates :password,  presence: true, length:  {minimum: 3}
  validates :password_confirmation,  presence: true, length:  {minimum: 3}
  validates_presence_of :email
  validates_uniqueness_of :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  $global_admin = [['Администратор', 0], ['Глобальный администратор', 1]]

  $email_globadmin =  'jiliaevyp@catelecom.ru'
  $password_globadmin = '1'    #"123456"

  #attr_accessible :email, :password, :password_confirmation

  #attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password #, :password_confirmation, :on => :create
  validates_presence_of :password, :on => :create


  def authenticate(email, password)
    @admin = Admin.find_by_email(email)
    if @admin && @admin.password_hash == BCrypt::Engine.hash_secret(password, @admin.password_salt)
      @admin
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
