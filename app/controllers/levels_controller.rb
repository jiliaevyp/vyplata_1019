class LevelsController < ApplicationController
  before_action :set_level, only: [:show, :edit, :update, :destroy]

  # GET /levels
  # GET /levels.json
  def index
    @id = params[:format]
    $admin_id = params[:format].to_i
    @admin          = Admin.find($admin_id)
    @personal       = Personal.find(@admin.personal_id)
    @levels         = Level.order(:access_controller).where(admin_id: @admin.id)
    @mond       = Mond.last
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
    @level        = Level.find(params[:id])
    @admin        = Admin.find(@level.admin_id)
    @personal     = Personal.find(@admin.personal_id)
    @mond         = Mond.last
  end

  # GET /levels/new
  def new
    @admin        = Admin.find($admin_id)
    @personal     = Personal.find(@admin.personal_id)
    @level        = Level.new
    @mond         = Mond.last
  end

  # GET /levels/1/edit
  def edit
    @level        = Level.find(params[:id])
    @admin        = Admin.find(@level.admin_id)
    @personal     = Personal.find( @admin.personal_id)
    @mond         = Mond.last
  end

  # POST /levels
  # POST /levels.json
  def create
    @admin          = Admin.find($admin_id)
    @personal       = Personal.find(@admin.personal_id)
    @level          = Level.new(level_params)
    @level.admin_id = @admin.id
    if @level.access_controller == $tabels         # delete old record Tabel for tabels/params[:format] == time/tabel/buchtabel
      Level.where(admin_id: @admin.id, access_controller: @level.access_controller, format: @level.format).delete_all
    else                                            # delete old record Monds/Comment/Personal for access_controller
      Level.where(admin_id: @admin.id, access_controller: @level.access_controller).delete_all
    end
    @level.save
    respond_to do |format|
      if @level.save
        #abort @level.access_controller.inspect
        if @level.access_controller == "monds" #'$monds'
          @level.format = $format_unknown
          #abort @level.format.inspect
        end
        if  @level.access_controller == $personals ||  @level.access_controller == $comments
          @level.format = $format_unknown
        end
        @level.save
        format.html { redirect_to @level} #, notice: 'Карта доступа успешно создана.' }
        format.json { render action: 'show', status: :created, location: @level }
      else
        format.html { render action: 'new' }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /levels/1
  # PATCH/PUT /levels/1.json
  def update
    @level        = Level.find(params[:id])
    @admin        = Admin.find(@level.admin_id)
    @personal       = Personal.find(@admin.personal_id)
    respond_to do |format|
      if @level.update(level_params)
        #abort @level.access_controller.inspect
        #abort @level.access_all_otdel.inspect
        format.html { redirect_to @level} #, notice: 'Карта доступа успешно изменена'  }
        format.json { render action: 'show', status: :ok, location: @level }
      else
        format.html { render action: 'edit' }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    admin_id = @level.admin_id
    @level.destroy
    respond_to do |format|
      format.html { redirect_to levels_url(admin_id)} #, notice: 'Карта доступа удалена' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level
      if params[:id]
        @level = Level.find(params[:id])
      else
        @level  = Level.find($admin_id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def level_params
      params.require(:level).permit(:admin_id, :access_controller, :format, :format_next, :access_full, :access_all_otdel, :access_new,
                                    :access_edit, :access_show, :access_index, :access_del, :access_print, :access_email)
    end
end
