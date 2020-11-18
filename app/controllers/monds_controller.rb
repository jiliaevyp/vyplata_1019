class MondsController < ApplicationController
  before_action :set_mond, only: [:show, :edit, :update, :destroy]
  before_action :checkadmin
  #rescue_from MondsController::RecordNotFound, with: "monds/mond_record_notfound_error"

    # GET /monds
  # GET /monds.json
  def index
    @monds = Mond.where(yahre: $jetzt_yahre).order(:num_monat)
      if @monds.nil?
        $jetzt_yahre  = nil
        $jetzt_num_monat = nil
        $jetztmonat = nil
        $flag_for_personals = 0
        $flag_for_admin     = 0
      else
        @mond = Mond.order(:num_monat).last
        $flag_for_personals = 1
        @personals = Personal.order(:title)
        if @personals.count == 0
          $flag_for_admin   = 0
        else
          $flag_for_admin   = 1
        end
        if @access_full > 0
          commit_block_time
          commit_block_tabel
          commit_block_buchtabel
        end
      end

  end

  # GET /monds/1
  # GET /monds/1.json
  def show
    @mond = Mond.find(params[:id])
    commit_block_mond
  end

  # GET /monds/new
  def new
    @mond = Mond.new
  end

  # GET /monds/1/edit
  def edit
    @mond = Mond.find(params[:id])
  end

  # POST /monds
  # POST /monds.json
  def create
    @mond = Mond.new(mond_params)
    @mond.block_mond      = 0
    @mond.block_personal  = 0
    @mond.block_real_personal  = 0
    @mond.block_comment   = 0
    @mond.block_timetabel = 0
    @mond.block_tabel     = 0
    @mond.block_buchtabel = 0
    Mond.where(yahre: @mond.yahre, num_monat: @mond.num_monat).delete_all
    respond_to do |format|
      if @mond.save
        $jetzt_yahre = @mond.yahre
        $jetzt_num_monat  = @mond.num_monat
        new_tabel             # создание новой ведомости
        format.html { redirect_to @mond} #, notice:'Созданы новый месяц и ведомость' }
        format.json { render action: 'show', status: :created, location: @mond }
      else
        format.html { render action: 'new' }
        format.json { render json: @mond.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monds/1
  # PATCH/PUT /monds/1.json
  def update
    @mond = Mond.find(params[:id])
    respond_to do |format|
      if @mond.update(mond_params)
        @mond.save
        $jetzt_yahre = @mond.yahre
        $jetzt_num_monat = @mond.num_monat
        format.html { redirect_to @mond} #, notice: 'Сведения по месяцу успешно изменены' }
        format.json { render :show, status: :ok, location: @mond }
      else
        format.html { render :edit }
        format.json { render json: @mond.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monds/1
  # DELETE /monds/1.json
  def destroy
    @mond = Mond.find(params[:id])
    @mond.destroy
    respond_to do |format|
      format.html { redirect_to monds_url, notice: ('Месяц и ведомость удалены') }
      format.json { head :no_content }
    end
  end

  def new_tabel               #создание новой ведомости
    @personals  = @personals  = Personal.where(real: $real[1]).order(:title)    #  выбрали только тех кто в штате
    if @personals                                                     # @personals is not empty
      @personals.each do |f|
        @mond = Mond.find_by(yahre: $jetzt_yahre, num_monat: $jetzt_num_monat)
        @tabel  = Tabel.new
        @tabel.mond_id       = @mond.id
        @tabel.kfnalog       = @mond.kfnalog
        @tabel.num_monat     = @mond.num_monat
        @tabel.yahre         = @mond.yahre
        @tabel.tag           = @mond.tag
        @tabel.hour          = @mond.hour
        @tabel.kfoberhour    = @mond.kfoberhour
        @tabel.procentsocial = @mond.procentsocial
        @tabel.personal_id   = f.id
        @tabel.title         = f.title
        @tabel.forname       = f.forname
        @tabel.fornametwo    = f.fornametwo
        @tabel.kadr          = f.kadr
        @tabel.email         = f.email
        @tabel.num_otdel     = f.num_otdel
        @tabel.tarifhour     = f.tarifhour
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
    end
  end


  def set_monat
    #abort params.inspect
    @mond = Mond.find(params[:id])
    $jetzt_yahre = @mond.yahre
    $jetzt_monat = $monat_array[@mond.num_monat.to_i]
    $jetzt_num_monat  = @mond.num_monat
    respond_to do |format|
      format.html { redirect_to mond_path} #, notice: 'Установлен новый рабочий месяц' }
      format.json { head :no_content }
    end
  end

  # обработка кнопки блокировки/разблокировки табеля рабочего времени
  def commit_block_mond
    @commit_open   = params[:commit_open_mond]            # была нажата "открыть ведомость"
    @commit_close  = params[:commit_close_mond]            # была нажата "Закрыть ведомость"

    if @commit_open
      @mond.block_mond = 0
      @mond.save
    end
    if @commit_close
      @mond.block_mond = 1           # изменения запрещены
      @mond.save
    end
  end

  # обработка кнопки блокировки/разблокировки табеля рабочего времени
  def commit_block_time
    @commit_open   = params[:commit_open_timetabel]            # была нажата "открыть ведомость"
    @commit_close  = params[:commit_close_timetabel]            # была нажата "Закрыть ведомость"
    if @commit_open
      @mond.block_timetabel = 0
      @mond.block_tabel = 0           # табель начисления и ведомость тоже разблокируются
      @mond.block_buchtabel = 0
      @mond.block_comment = 0         # изменения разблокируются для отзывов
      @mond.save
    end
    if @commit_close
      @mond.block_timetabel = 1           # изменения запрещены
      @mond.save
    end
  end

  # обработка кнопки блокировки/разблокировки  табеля начисления
  def commit_block_tabel
    @commit_open   = params[:commit_open_tabel]            # была нажата "открыть ведомость"
    @commit_close  = params[:commit_close_tabel]            # была нажата "Закрыть ведомость"
    if @commit_open
      @mond.block_tabel = 0
      @mond.block_buchtabel = 0       # ведомость тоже разблокируется
      @mond.block_comment = 0         # изменения разблокируются для отзывов
      @mond.save
    end
    if @commit_close
      @mond.block_tabel = 1           # изменения запрещены
      @mond.block_timetabel = 1       # изменения запрещены и для табеля рабочего времени
      @mond.block_comment = 1         # изменения запрещены и для отзывов
      @mond.save
    end
  end
  # обработка кнопки блокировки/разблокировки  ведомости
  def commit_block_buchtabel
    @commit_open   = params[:commit_open_buchtabel]            # была нажата "открыть ведомость"
    @commit_close  = params[:commit_close_buchtabel]            # была нажата "Закрыть ведомость"
    if @commit_open
      @mond.block_buchtabel = 0
      @mond.save
    end
    if @commit_close
      @mond.block_buchtabel = 1       # изменения запрещены
      @mond.block_timetabel = 1       # изменения запрещены и для табеля рабочего времени
      @mond.block_tabel = 1           # изменения запрещены и для табеля начисления
      @mond.save
    end
  end

  def mond_record_notfound_error
    #raise redirect_to start_monds_path, :notice => "Неправильный код старницы!"
    raise redirect_to monds_url, :notice => "Mond record not found!" #никого не нашли
  end

  private



    # Use callbacks to share common setup or constraints between actions.
    def set_mond
      @mond = Mond.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mond_params
      params.require(:mond).permit(:yahre, :monat, :num_monat, :tag, :hour, :kfoberhour, :kfnalog,
                                   :procentsocial, :block_mond, :block_personal, :block_comment, :block_timetabel,
                                   :block_tabel, :block_buchtabel, :add_time, :close_update, :reservstring, :reservint,
                                   :created_at, :updated_at)
    end
end
