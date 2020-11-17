class PersonalsController < ApplicationController
  before_action :set_personal, only: [:show, :edit, :update, :destroy]
  before_action :checkadmin

  # GET /personals
  # GET /personals.json
  def index
    if @access_all_otdel > 0 || $glob_permition > 0
      @otdel = $all_otdel
    else
      @otdel  = $otdel_long[$real_admin.num_otdel] +"  отдел"
    end
    @sort_by_name = params[:sort_by_name]
    @sort_by_otdel = params[:sort_by_otdel]
    @sort_by_kadr = params[:sort_by_kadr]
    if @sort_by_name.nil? && @sort_by_otdel.nil? && @sort_by_kadr.nil?
      @sort_by_name = "1"
    end
    @mond = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre)
    if $glob_permition > 0
      case "1"
        when @sort_by_name
        @personals = Personal.order(:title)
        when @sort_by_otdel
        @personals = Personal.order(:num_otdel)
        when  @sort_by_kadr
        @personals = Personal.order(:kadr)
      end

    else
      if $real_admin && @level       # if Personal is not empty
        if @access_all_otdel > 0
          case "1"
          when @sort_by_name
          @personals = Personal.order(:title)
          when @sort_by_otdel
          @personals = Personal.order(:num_otdel)
          when  @sort_by_kadr
          @personals = Personal.order(:kadr)
          end
        else
          case "1"
          when @sort_by_name
            @personals = Personal.where(num_otdel: $real_admin.num_otdel).order(:title)
          when  @sort_by_kadr
            @personals = Personal.where(num_otdel: $real_admin.num_otdel).order(:kadr)
          end
          @personals = Personal.where(num_otdel: $real_admin.num_otdel).order(:title)#, id: not($real_admin.id))#&&(where.not(id: $real_admin.id)).order(:title) # доступ только к своему отделу
        end
      end
    end
    if @personals
      $flag_for_admin = 1
    else
      $flag_for_admin = 0
    end
    commit_block
  end

  # GET /personals/1
  # GET /personals/1.json
  def show
    @personal = Personal.find(params[:id])
    @mond = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre)
  end

  # GET /personals/new
  def new
    @personal = Personal.new
  end

  # GET /personals/1/edit
  def edit
    @personal   = Personal.find(params[:id])
  end

  # POST /personals
  # POST /personals.json
  def create
    @personal= Personal.new(personal_params)
    @personal.otdel = $otdel_long[@personal.num_otdel.to_i]
    respond_to do |format|
      if @personal.save
        format.html { redirect_to @personal} #, notice: 'Персональная карта сотрудника сохранена' }
        format.json { render action: 'show', status: :created, location: @personal }
      else
        format.html { render action: 'new' }
        format.json { render json: @personal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personals/1
  # PATCH/PUT /personals/1.json
  def update
      @personal = Personal.find(params[:id])
      @personal.otdel = $otdel_long[@personal.num_otdel.to_i]
      @mond = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre)
      respond_to do |format|
        if @personal.update(personal_params)
          format.html { redirect_to personal_path(personal_id: @personal.id)}#, notice: 'Персональная карта изменена'}
          format.json { render action: 'personals/show', status: :created, location: @personal }
        else
          format.html { render action: 'edit' }
          format.json { render json: @personals.errors, status: :unprocessable_entity }
        end
      end
  end

  # DELETE /personals/1
  # DELETE /personals/1.json
  def destroy
    @personal= Personal.find(params[:id])
    @personal.destroy
    respond_to do |format|
      format.html { redirect_to personals_url, notice: 'Персональная карта и все связанные записи удалены' }
      format.json { head :no_content }
    end
  end

  # обработка кнопки блокировки персонала


  def commit_block
    @commit_open   = params[:commit_open]            # была нажата "открыть таблицу Personal"
    @commit_close  = params[:commit_close]            # была нажата "Закрыть таблицу Personal"
    if @commit_open
      @mond.block_personal = 0
      @mond.save
    end
    if @commit_close
      @mond.block_personal = 1           # изменения запрещены
      @mond.save
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal
      @personal = Personal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_params
      params.require(:personal).permit(:title, :forname, :fornametwo, :image_url, :kadr,:otdel, :num_otdel, :real,
                                       :tarifhour, :begdata,:enddata, :bilding, :borndata, :familie, :kinder,:haus,
                                       :auto, :address, :realaddress, :tel, :email,:werte, :information, :close_update,
                                       :reservstring, :reservint, :personal_admin, :encrypted_password, :password_digest,
                                       :password, :open_password)
    end
end
