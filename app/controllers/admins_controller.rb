class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  # GET /admins
  # GET /admins.json
  def index
    @admins     = Admin.order(:id)
    @personals  = Personal.where(personal_admin: $personal_admin).order(:title)
    @mond       = Mond.last
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
    @admin        = Admin.find(params[:id])
    $admin_id     = @admin.id
    #@personals  = Personal.where(personal_admin: $personal_admin).order(:title)
    @mond       = Mond.last
    if @admin.personal_id
      @personal    = Personal.find(@admin.personal_id)
      @admin_email = @personal.email
    end
  end

  # GET /admins/new
  def new
    @admin = Admin.new
    @mond  = Mond.last
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
    @mond       = Mond.last
    if @admin.personal_id
      @personal = Personal.find_by(id: @admin.personal_id)
    end
  end

  # POST /admins
  # POST /admins.json
  def create
    @admin        = Admin.new(admin_params)
    @personal     = Personal.find_by(id: @admin.personal_id)
    @personals    = Personal.where(personal_admin: $personal_admin)
    @admin.email  = @personal.email
    if @admin.save
      respond_to do |format|
      format.html { redirect_to @admin, notice: 'Новый администратор создан' }
      format.json { render :show, status: :created, location: @admin }
      end
    else
      respond_to do |format|
        @admin.password = ''
        flash[:danger]  = 'Ошибка пароля!'
        format.html { render :new}
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: 'Новый администратор изменен' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin= Admin.find(params[:id])
    Level.where(admin_id: @admin.id).delete_all
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Администратор и все записи доступа удалены!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
      if @admin
        @personal = Personal.find_by(id: @admin.personal_id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:personal_id, :email, :password, :password_confirmation,:password_hash, :password_salt)
    end
end
