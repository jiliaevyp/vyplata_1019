class CommentsController < ApplicationController

  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :checkadmin
  # GET /comments
  # GET /comments.json
  def index
    @mond       = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @personals  = Personal.order(:title)
    if (@mond.nil? == false) & (@personals.nil? == false)             # проверяем что есть запись Mond и @personals
      if @access_all_otdel > 0            # access to full otdel
        @tabels   = Tabel.where(mond_id: @mond.id).order(:title)
      else                                      # access only to selbst otdel
        @tabels   = Tabel.where(mond_id: @mond.id, num_otdel: @real_admin.num_otdel).order(:title)
      end
      if @access_full > 0
        commit_block
      end
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment  = Comment.find(params[:id])
    if @comment
      #@tabel    = Tabel.find(@comment.tabel_id)
      @personal = Personal.find(@comment.personal_id)
      @mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
      @tabel    = Tabel.find_by(personal_id: @personal.id, mond_id: @mond.id, )
    end
  end

  # просмотр выборки отзывов за месяц
  def comments_show
    @mond   = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    #abort @mond.num_monat.inspect
    @srnplunus  = 0
    @tabel  = Tabel.find(params[:id])
    if @tabel
      @personal = Personal.find(@tabel.personal_id)
      @comments = Comment.where(personal_id: @personal.id, mond_id: @mond.id, )
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
    @mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @tabel= Tabel.find(params[:format])
    $tabel_id = @tabel.id
    @personal = Personal.find(@tabel.personal_id)
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @comment  = Comment.find(params[:id])
    @personal = Personal.find(@comment.personal_id)
    @tabel    = Tabel.find(@comment.tabel_id)
  end

  # POST /comments
  # POST /comments.json
  def create
    @mond     = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
    @tabel= Tabel.find($tabel_id)
    @personal = Personal.find(@tabel.personal_id)
    @comment  = Comment.new(comment_params)
    @comment.tabel_id   =  @tabel.id
    @comment.personal_id    =  @personal.id
    @comment.mond_id        =  @mond.id
    @comment.commenter_title=  @real_admin.title
    @comment.data           =  Time.zone.now
    #set_tag_hour
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
        @mond = Mond.find_by(num_monat: $jetzt_num_monat, yahre: $jetzt_yahre )
        format.html { redirect_to @comment, notice: 'Отзыв на сотрудника обновлен' }
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
      format.html { redirect_to comments_url, notice: 'Отзыв удален' }
      format.json { head :no_content }
    end
  end

  # обработка кнопки аблокировки comments
  def commit_block
    @commit_open  = "Открыть отзывы"
    @commit_close = "Закрыть отзывы"
    @commit       = params[:block]                            # была нажата "Закрыть табель"
    if @commit.nil? == false
      case @commit
      when @commit_close
        @mond.block_comment = 1
        @mond.save
      when @commit_open
        @mond.block_comment = 0
        @mond.save
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:mond_id, :personal_id, :timetabel_id, :commenter_id, :title, :email,
                                      :commenter_title, :body, :plunus, :data, :close_update, :reservstring, :reservint)
    end
end
