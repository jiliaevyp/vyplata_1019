class CommentsController < ApplicationController

  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :checkadmin
  # GET /comments
  # GET /comments.json
  def index
    @mond       = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    if @access_all_otdel > 0
      @otdel = $all_otdel
    else
      @otdel  = $otdel_long[$real_admin.num_otdel] +"  отдел"
    end
    if @mond.nil? == false            # проверяем что есть запись Mond и @personals
      if @access_all_otdel > 0            # access to full otdel
        @tabels = Tabel.where(mond_id: @mond.id).where.not(personal_id:$real_admin.id).order(:title)
      else                            # access only to selbst otdel
        @tabels = Tabel.where(mond_id: @mond.id,num_otdel: $real_admin.num_otdel).where.not(personal_id:$real_admin.id).order(:title)
      end
      if @access_full > 0
        commit_block_comment
      end
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment  = Comment.find(params[:id])
    if @comment
      @tabel    = Tabel.find(@comment.tabel_id)
      #@mond     = Mond.find(@comment.mond_id )
    end
  end

  # просмотр выборки отзывов за месяц
  def comments_show
    #@mond   = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @srnplunus  = 0
    @tabel  = Tabel.find(params[:id])
    @mond   = Mond.find(@tabel.mond_id)
    if @tabel
      #@personal = Personal.find(@tabel.personal_id)
      @comments = Comment.where(tabel_id: @tabel.id, mond_id: @mond.id)
      @sumplunus = @comments.sum(:plunus)
      @count_plunus = @comments.count
      if @count_plunus > 0
        @srnplunus  = @sumplunus / @count_plunus
      else
        @srnplunus  = 0
      end
    end
  end

  # GET /comments/new
  def new
    #@mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @tabel    = Tabel.find(params[:format])
    @mond   = Mond.find(@tabel.mond_id)
    $tabel_id = @tabel.id
    #@personal = Personal.find(@tabel.personal_id)
    @comment  = Comment.new
  end

  # GET /comments/1/edit
  def edit
    #@mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @comment  = Comment.find(params[:id])
    @mond     = Mond.find(@comment.mond_id )
    #@personal = Personal.find(@comment.personal_id)
    @tabel    = Tabel.find(@comment.tabel_id)
  end

  # POST /comments
  # POST /comments.json
  def create
    #@mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @tabel    = Tabel.find($tabel_id)
    #@mond     = Mond.find(@tabel.mond_id)
    #@personal = Personal.find(@tabel.personal_id)
    @comment  = Comment.new(comment_params)
    @comment.tabel_id       =  @tabel.id
    @comment.personal_id    =  @tabel.personal_id
    @comment.mond_id        =  @tabel.mond_id
    @comment.commenter_title=  $real_admin.title
    @comment.title          =  @tabel.title
    @comment.forname        =  @tabel.forname
    @comment.fornametwo     =  @tabel.fornametwo
    @comment.email          =  @tabel.email
    @comment.data           =  Time.zone.now
    @comment.save
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment}
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      @comment.updated_at = Time.zone.now
      @comment.data       = Time.zone.now
      if @comment.update(comment_params)
        #@mond = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
        format.html { redirect_to @comment} #, notice: 'Отзыв на сотрудника обновлен' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url} #, notice: 'Отзыв удален' }
      format.json { head :no_content }
    end
  end

  # обработка кнопки блокировки/разблокировки реестра комментов
  def commit_block_comment
    @commit_open   = params[:commit_open_comment]            # была нажата "открыть реестр комментов"
    @commit_close  = params[:commit_close_comment]            # была нажата "Закрыть реестр комментов"
    if @commit_open
      @mond.block_comment = 0
      @mond.save
    end
    if @commit_close
      @mond.block_comment = 1           # изменения запрещены
      @mond.save
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:mond_id, :personal_id, :timetabel_id, :commenter_id, :title, :forname,
                                      :fornametwo, :email, :num_monat, :yahre,
                                      :commenter_title, :body, :plunus, :data, :close_update, :reservstring, :reservint)
    end
end
