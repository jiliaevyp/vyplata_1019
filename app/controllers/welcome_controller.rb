class WelcomeController < ApplicationController

  #before_action :checkadmin
  $flag_for_monds       = 0
  $flag_for_personals   = 0
  $flag_for_timetabels  = 0
  $flag_for_comments    = 0
  $flag_for_tabel       = 0
  $flag_for_buchtabel   = 0
  $flag_for_admin       = 0
  $glob_permition       = 0 # флаг глобального доступа

  def index
    lastdate
    if params[:format] == 'exit' || params[:format] == nil
      $email_admin = ''
      $global_admin =''
      $glob_permition = 0
    end
    @admin = Admin.find_by(email: $email_admin)
    @monds = Mond.order(:yahre)
    @personals=  Personal.order(:title)
  end

  def new
  end

  def show
  end

  def create
    #  глобальный администратор
    #-----------------------------------------------------------------
    $glob_permition = 0
    params_email    = params[:email]
    @personals = Personal.all
    if @personals.count == 0
      $email_admin    = params_email[0]
    else
      $email_admin    = params_email
    end
    params_pass = params[:pass]
    $pass_admin    = params_pass

    #-----------------------------------------------------------------
    # проверяем на глобального администратора
    if  $email_admin == $email_globadmin && $pass_admin == $password_globadmin
      $glob_permition = 1
      @personals  = Personal.order(:title)
      @admins     = Admin.order(:title)
      @monds      = Mond.order(:id)
      #abort params_email.inspect
      lastdate
      @check_mond = Mond.last
      if @check_mond.nil?               #Monds is not exist?
        $flag_for_monds     = 1         #access for monds
        $flag_for_personals = 0         #access denied for personals
        $flag_for_admin     = 0         #access denied for admins
        redirect_to new_mond_url, :notice => "Monds data is empty!"        # go to monds
      else
        if @personals.nil? || @personals.empty?   #@personal is not exist?
          $flag_for_admin = 0                     #access denied for admins
          redirect_to personals_url, :notice => "Personals data is empty!"    # база персонала пуста выходим на заполнение базы Personal
        else
          $flag_for_admin = 1
          $flag_for_personals = 1
          redirect_to admins_url        # выходим на заполненение базы  Admin
        end
      end
    else
      # ищем администратора из базы Admin
      $glob_permition = 0
      #@admin = Admin.find_by(email: $email_admin[0])
      $admin = Admin.find_by(email: params[:email])
      #abort @admin.email.inspect
      if $admin
        #$email_admin = @admin.email
        if $admin.authenticate(params[:email], params[:pass])
          $real_admin = Personal.find_by(id: $admin.personal_id)
          #@real_admin = @personal#.title
          #if @admin.authenticate($email_admin, $pass_admin)
          #abort 'pass succefull'
          #
          @mond = Mond.last                 #нашли администратора
            if @mond
              redirect_to  monds_path#, :notice => "Succefull!"              # открываем последний месяц
            else
              redirect_to monds_path, :notice => "Succefull! Monds data is empty" #месяцев нет
            end
        else
          redirect_to welcome_index_url(format:"exit"), :notice => "Invalid password" #никого не нашли
        end
      else
        redirect_to welcome_index_url(format:"exit"), :notice => "Admin not found!" #никого не нашли
      end
    end
  end



#  восстановление даты из базы Mond
  def lastdate
    @monds = Mond.order(:yahre)  # выборка последнего года и месяца
     if @monds
       #@mond = @monds.last
       @mond = Mond.order(:num_monat).last
      end
      if @mond
        $jetzt_yahre = @mond.yahre
        $jetzt_num_monat = @mond.num_monat
        $jetztmonat     = $monat_array[@mond.num_monat.to_i]
      else
        jetzt_yahre = params[:yahre]
        if jetzt_yahre != nil
          $jetzt_yahre = jetzt_yahre
        end
        @month1 = params[:date]
        if @month1 != nil
          @num = @month1[:month]
          n = @num.to_i
          $jetzt_num_monat = @num
          $jetztmonat = $monat_array[n - 1]
        end
      end
  end


  private
  def welcome_params
    params.require(:welcome).permit(:email, :pass)
  end
end

