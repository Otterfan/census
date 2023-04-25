class Admin::NewsController < ApplicationController
  before_action :set_admin_news, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :restrict_access

  skip_before_action :verify_authenticity_token

  def restrict_access
    redirect_to "/" unless current_user && current_user.user_type != 'viewer'
  end

  # GET /admin/news
  # GET /admin/news.json
  def index
    @admin_news = Admin::News.all.page(params[:page])
  end

  # GET /admin/news/1
  # GET /admin/news/1.json
  def show
  end

  # GET /admin/news/new
  def new
    @admin_news = Admin::News.new
  end

  # GET /admin/news/1/edit
  def edit
  end

  # POST /admin/news
  # POST /admin/news.json
  def create
    @admin_news = Admin::News.new(admin_news_params)

    respond_to do |format|
      if @admin_news.save
        format.html { redirect_to @admin_news, notice: 'News was successfully created.' }
        format.json { render :show, status: :created, location: @admin_news }
      else
        format.html { render :new }
        format.json { render json: @admin_news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/news/1
  # PATCH/PUT /admin/news/1.json
  def update
    respond_to do |format|
      if @admin_news.update(admin_news_params)
        format.html { redirect_to @admin_news, notice: 'News was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_news }
      else
        format.html { render :edit }
        format.json { render json: @admin_news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/news/1
  # DELETE /admin/news/1.json
  def destroy
    @admin_news.destroy
    respond_to do |format|
      format.html { redirect_to admin_news_index_url, notice: 'News was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_news
      @admin_news = Admin::News.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_news_params
      params.require(:admin_news).permit(:brief_content, :content, :note, :posted_on, :expires_on, :published)
    end
end
