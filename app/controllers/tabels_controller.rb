class TabelsController < ApplicationController
  before_action :set_tabel, only: [:show, :edit, :update, :destroy]
  before_action :checkadmin
  #rescue_from Tabel::NoMethodError, with: :tabel_nometod_error
    # GET /tabels
  # GET /tabels.json
  def index
    @mond       = Mond.find_by(num_monat: $jetzt_num_monat,yahre: $jetzt_yahre )
    #abort params[:format].inspect
    @sort_by_name = params[:sort_by_name]
    @sort_by_otdel = params[:sort_by_otdel]
    @sort_by_kadr = params[:sort_by_kadr]
    if @sort_by_name.nil? && @sort_by_otdel.nil? && @sort_by_kadr.nil?
      @sort_by_name = "1"
    end
    #abort @access_print.inspect
    if @mond.nil? == false         # проверяем что есть запись Mond
      if @access_all_otdel > 0
        case "1"
        when @sort_by_name
          @tabels = Tabel.where(mond_id: @mond.id).order(:title)
        when @sort_by_otdel
          @tabels = Tabel.where(mond_id: @mond.id).order(:num_otdel)
        when  @sort_by_kadr
          @tabels = Tabel.where(mond_id: @mond.id).order(:kadr)
        end
      else
        case "1"
        when @sort_by_name
          @tabels = Tabel.where(mond_id: @mond.id,num_otdel: $real_admin.num_otdel).order(:title)
        when  @sort_by_kadr
          @tabels = Tabel.where(mond_id: @mond.id,num_otdel: $real_admin.num_otdel).order(:kadr)
        end
      end
      itog
      #add_tabel
    end

  end

    # GET /tabels/1
    # GET /tabels/1.json
    # просмотр карты табеля       params[:format]==$format_time
    # просмотр карты начисления   params[:format]==$format_tabel
    # просмотр карты ведомости    params[:format]==$format_buchtabel
  def show
    @tabel      = Tabel.find(params[:id])
    @mond       = Mond.find(@tabel.mond_id)
    @personal   = Personal.find_by(id: @tabel.personal_id)       # добавить поле tabel_id in Comment
    @comments   = Comment.where(mond_id: @mond.id, tabel_id: @tabel.id)
    calc_tabel
    send_cardtabel_to_mail
    @show_history_tabels = Tabel.where(yahre: @mond.yahre, personal_id: @personal.id)
    if @show_history_tabels
      @summa_history           = @show_history_tabels.sum(:summa)
    else
      @summa_history = 0
    end
    sassoft_send_cardtabel_to_mail
  end

    #GET /tabels/new
  def new
    @tabel        = Tabel.new
  end

    # GET /tabels/1/edit
  def edit
    @tabel      = Tabel.find(params[:id])
    $params = params[:format]
    @mond       = Mond.find(@tabel.mond_id)
    @personal   = Personal.find_by(id: @tabel.personal_id)       # добавить поле tabel_id in Comment

    @comments   = Comment.where(mond_id: @mond.id, personal_id: @tabel.personal_id)
    @sumplunus = @comments.sum(:plunus)
    @count_plunus = @comments.count
    if @count_plunus > 0
      @srnplunus  = @sumplunus / @count_plunus
    else
      @srnplunus  = 0
    end
  end

    # POST /tabels
    # POST /tabels.json
  def create
    @tabel      = Tabel.new(tabel_params)
    #@personal   = Personal.find(@tabel.personal_id)
    @mond       = Mond.find_by(mond_id: @mond.id, yahre: $jetzt_yahre)
    @tabel_old  = Tabel.find_by(personal_id: @personal.id, mond_id: @mond.id, yahre: $jetzt_yahre ) #проверка на сущ запись
    unless @tabel_old
      add_tabel
      calc_tabel
      @tabel.save
      respond_to do |format|
        if @tabel.save
          format.html { redirect_to tabel_path(@tabel), notice: 'Карта табеля успешно создана' }
          format.json { render :show, status: :created, location: tabel_path(@tabel) }
        else
          format.html { redirect_to  new_tabel_path(@tabel)}
          format.json { render json: @tabel.errors, status: :unprocessable_entity }
        end
      end
    end
  end

    # PATCH/PUT /tabels/1
    # PATCH/PUT /tabels/1.json
  def update
    @tabel     = Tabel.find(params[:id])
    @personal  = Personal.find(@tabel.personal_id)
    @mond      = Mond.find(@tabel.mond_id)
    #@tabel.save
    #calc_tabel
    respond_to do |format|
      if @tabel.update(tabel_params)
        calc_tabel
        @tabel.save
        case  $params
        when $format_time
          format.html { redirect_to tabel_path(@tabel,format: $format_time), notice: 'Карта начисления сохранена' }
          format.json { render :show, status: :ok, location: @tabel }
        when $format_tabel
          format.html { redirect_to tabel_path(@tabel,format: $format_tabel), notice: 'Карта начисления сохранена' }
          format.json { render :show, status: :ok, location: @tabel }
        when $format_buchtabel
          format.html { redirect_to tabel_path(@tabel,format: $format_buchtabel), notice: 'Карта начисления сохранена' }
          format.json { render :show, status: :ok, location: @tabel }
        end
      else
        case  $params
        when $format_time
          format.html { redirect_to edit_tabel_path(@tabel, format: $format_time)}
          format.json { render json: @tabel.errors, status: :unprocessable_entity }
        when $format_tabel
          format.html { redirect_to edit_tabel_path(@tabel, format: $format_tabel)}
          format.json { render json: @tabel.errors, status: :unprocessable_entity }
        when $format_buchtabel
          format.html { redirect_to edit_tabel_path(@tabel, format: $format_buchtabel)}
          format.json { render json: @tabel.errors, status: :unprocessable_entity }
        end
      end
    end
  end

    # DELETE /tabels/1
    # DELETE /tabels/1.json
  def destroy
    @tabel  = Tabel.find(params[:id])
    @tabel.destroy
    respond_to do |format|
      format.html { redirect_to tabels_url, notice: 'Карта начисления удалена' }
      format.json { head :no_content }
    end
  end
  def add_tabel               #добавление нового табеля
    @tabel= Tabel.new
    @tabel.personal_id   = @personal.id
    @tabel.title         = @personal.title
    @tabel.kadr          = @personal.kadr
    @tabel.email         = @personal.email
    @tabel.num_otdel     = @personal.num_otdel
    @tabel.tarifhour     = @personal.tarifhour
    @tabel.mond_id       = @mond.id
    @tabel.kfnalog       = @mond.kfnalog
    @tabel.num_monat     = @mond.num_monat
    @tabel.yahre         = @mond.yahre
    @tabel.tag           = @mond.tag
    @tabel.hour          = @mond.hour
    @tabel.kfoberhour    = @mond.kfoberhour
    @tabel.procentsocial = @mond.procentsocial
    @tabel.tagemach       = 0
    @tabel.hourmach       = 0
    @tabel.oberhour       = 0
    @tabel.reisetage      = 0
    @tabel.hourgeld       = 0
    @tabel.oberhourgeld   = 0
    @tabel.oklad          = 0
    @tabel.proc_bonus     = 0
    @tabel.bonus          = 0
    @tabel.nadbavka       = 0
    @tabel.reisegeld      = 0
    @tabel.urlaub         = 0
    @tabel.urlaubgeld     = 0
    @tabel.krankengeld    = 0
    @tabel.gehalt         = 0
    @tabel.textminus      = ' '
    @tabel.vsego          = 0
    @tabel.summa          = 0
    @tabel.nalog          = 0
    @tabel.naruki         = 0
    @tabel.social         = 0
    @tabel.save
  end

  def calc_tabel      #вычисления
    @tabel.hourgeld     = @tabel.hourmach*@tabel.tarifhour
    @tabel.oberhourgeld = @tabel.oberhour*@tabel.tarifhour*@tabel.kfoberhour
    @tabel.reisegeld    = @tabel.tarifhour*@tabel.reisetage*8
    @tabel.oklad        = @tabel.hourgeld + @tabel.oberhourgeld + @tabel.reisegeld
    @tabel.bonus        = @tabel.oklad*@tabel.proc_bonus/100
    @tabel.summa        = @tabel.oklad + @tabel.bonus + @tabel.nadbavka
    @tabel.vsego        = @tabel.summa + @tabel.krankengeld  + @tabel.urlaubgeld - @tabel.minus
    #@tabel.nalog        = @tabel.vsego * @tabel.kfnalog/100
    @tabel.naruki       = @tabel.vsego - @tabel.nalog
    @tabel.social       = @tabel.vsego * @tabel.procentsocial/100
    #@tabel.save
  end

  def itog
    if @tabels
      @sumhour         = @tabels.sum(:hourmach)
      @sumoberhour     = @tabels.sum(:oberhour)
      @sumreisetage    = @tabels.sum(:reisetage)
      @sumkrankentage  = @tabels.sum(:krankentage)
      @sumoklad        = @tabels.sum(:oklad)
      @sumnadbavka     = @tabels.sum(:nadbavka)
      @sumbonus        = @tabels.sum(:bonus)
      @sumreisegeld    = @tabels.sum(:reisegeld)
      @summa           = @tabels.sum(:summa)
      @sumurlaub       = @tabels.sum(:urlaub)
      @sumkrankengeld  = @tabels.sum(:krankengeld)
      @sumurlaub_geld  = @tabels.sum(:urlaubgeld)
      @summinus        = @tabels.sum(:minus)
      @sumvsego        = @tabels.sum(:vsego)
      @sumnalog        = @tabels.sum(:nalog)
      @sumnaruki       = @tabels.sum(:naruki)
      @sumsocial       = @tabels.sum(:social)
    end
  end

    # обработка кнопки отправки карты по  адресу Personal.mail  через UserMailer
  def send_cardtabel_to_mail
    @tabel  = Tabel.find(params[:id])
    @mond   = Mond.find(@tabel.mond_id)
    @mail_commit  = params[:send_cardtabel_to_mail]
    if @mail_commit.nil? == false
      respond_to do |format|
        UserMailer.welcome_email(@tabel).deliver_now
        format.html { redirect_to tabel_path(@tabel, format:"buchtabel"), notice: 'Карта отправлена на  '+ @tabel.email+'  через UserMailer'}
      end
    end
  end
    #
    # обработка кнопки отправки карты по  адресу @tabel.email
  def sassoft_send_cardtabel_to_mail
    @tabel  = Tabel.find(params[:id])
    @mond   = Mond.find(@tabel.mond_id)
    text_tabel_to_mail
    @mail_commit  = params[:sassoft_send_cardtabel_to_mail]
    if @mail_commit.nil? == false
      respond_to do |format|
        require "net/http"
        require "uri"
        require 'json'

        uri = URI('https://api.sassoft.ru/notify')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        req.body = {"message":"Hello world!","message_plain":"","from":"sendertab@catelecom.ru",
                    "from_address":"sendertab@catelecom.ru","title":"test","receiver":"jiliaevyp@catelecom.ru",
                    "type":"Email","token":"ac1884930cafed7554aeddf25e6487f3a9e48526"}.to_json
        res = http.request(req)
        print(res.inspect())

        format.html { redirect_to tabel_path(@tabel, format:"buchtabel"), notice: 'Карта отправлена на'+ @tabel.email+'через https://api.sassoft.ru/notify'}
      end
    end
  end

  def text_tabel_to_mail
    @tabel  = Tabel.find(params[:id])
    @mond   = Mond.find(@tabel.mond_id)
    @text_tabel = " <!DOCTYPE html><html><head>
    <meta content='html; charset=UTF-8' http-equiv='Content-Type' />
    <%= yield %>
    </head>
    <body>
    <table border>
    caption> <h3>Карта ведомости <br>"+ @tabel.title+"<br>"+ $monat_array[$jetzt_num_monat.to_i]+ "  "+ $jetzt_yahre + "</h3></caption>"+
        + "<tbody>"+
        "Должность    " + @tabel.kadr+"<br"+
        "Отдел        " +$otdel_long[@tabel.num_otdel.to_i]+ "<br>"+
        "Почасовая    "+sprintf("%0.02f руб", @tabel.tarifhour)+"<br>"+
        "</tbody> + </table>" + "</body>"+"</html>"

  end

  def send_tlg_message
    #вот для телеграма версия
    #
    # но он может отсылать сообщение только тем кто добавил бота https://telegram.me/sassoft_notifications_bot
    require "net/http"
    require "uri"
    require 'json'

    uri = URI('https://api.sassoft.ru/notify')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = {"message":"Hello world!","message_plain":"","from":"",
                "from_address":"","title":"","receiver":"31281382",
                "type":"Telegram","token":"ac1884930cafed7554aeddf25e6487f3a9e48526"}.to_json
    res = http.request(req)
    print(res.inspect())
  end

  private

  def tabel_nometod_error
    raise redirect_to "http://localhost:3000/monds"
    #raise redirect_to welcome_index_url(format:"exit"), :notice => "Invalid password" #никого не нашли
    #redirect_to welcome_index_url(format:"exit"), :notice => "Invalid password" #никого не нашли
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_tabel
      @tabel = Tabel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tabel_params
      params.require(:tabel).permit(:personal_id, :mond_id, :title, :kadr, :email, :num_otdel, :tarifhour, :num_monat, :yahre,
                                    :tag, :hour, :kfoberhour, :kfnalog, :procentsocial, :tagemach, :hourmach, :oberhour, :krankentage,
                                    :urlaub, :reisetage, :hourgeld, :reisegeld, :oberhourgeld, :oklad, :proc_bonus,
                                    :bonus, :nadbavka, :summa, :krankengeld, :reisetage,
                                    :urlaubgeld, :minus, :textminus, :nalog, :naruki, :social, :vsego, :close_update, :reservstring, :reservint)
    end
end
