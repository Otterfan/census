class Public::JournalsController < ApplicationController
  layout "public"

  before_action :authenticate_user!

  # GET /public/journals
  def index
    @journals = Journal.order(:title).page(params[:page])
  end

  # GET /public/journals/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@journals)
    @journal = Journal.find(params[:id])
    @referenced_texts = Text.where(:journal_id => @journal.id)
  end
end
