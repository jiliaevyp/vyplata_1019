class ApplicationController < ActionController::Base

  protected
  #rescue_from ApplicationController::NoMethodError, with: :tabel_nometod_error

  #  контроль прав доступа к страницам
  # проверяет на глобального администартора по $glob_permition > 0
  # если нет то ищет админа в базе Admin
  # @admin = Admin.find_by(email: $email_admin)
  # если не находит то выход = 0  "record is not found"
  # если нашел то
  # вытягивает  params[:controllers, :action, :format]
  # ищет в базе Level соответствующую странице действию и доп параметрам запись
  # если находит то устанавливает соотв флаги и return(1) else флаги =0 return(0)

private
  def tabel_nometod_error
    raise redirect_to welcome_index_url(format:"exit"), :notice => "Invalid request" #никого не нашли
    redirect_to :controller => 'welcome', :action => 'index'
    #redirect_to action: "welcome/index", id: 5
  end

  def checkadmin
    #-----------------# ищем запись в базе Admin-------------------
    @controller = params[:controller]
    @action =     params[:action]
    @format =     params[:format]
    #@admin = Admin.find_by(email: $email_admin)

    #abort @admin.title.inspect
    if $admin
      @real_admin = Personal.find_by(id: $admin.personal_id)
      #abort @admin.title.inspect
      #----------------ищем запись доступа  ---------------------
      @level = Level.find_by(admin_id: $admin.id, access_controller: @controller)
      if @level
        if @level.access_controller == "tabels"    # if "tabels" then new found by format "time" / "tabel" / "buchtabel"
          @level  = Level.find_by(admin_id: $admin.id, access_controller: @controller, format: @format)
          #abort @level.format.inspect
        end
      end
    end
    access_level
  end

  def access_level
    if @level
      @access_controller  = @level.access_controller
      @access_action      = @level.access_action
      @format             = @level.format
      @format_next        = @level.format_next
      @access_all_otdel   = @level.access_all_otdel
      @access_full        = @level.access_full
      @access_index       = @level.access_index
      @access_show        = @level.access_show
      @access_edit        = @level.access_edit
      @access_new         = @level.access_new
      @access_del         = @level.access_del
      @access_print       = @level.access_print
      @access_email       = @level.access_email
    else
      @access_controller  = 0
      @access_action      = 0
      @format             = 0
      @format_next        = 0
      @access_all_otdel   = 0
      @access_full        = 0
      @access_index       = 0
      @access_show        = 0
      @access_edit        = 0
      @access_new         = 0
      @access_del         = 0
      @access_print       = 0
      @access_email       = 0
    end
  end


end
