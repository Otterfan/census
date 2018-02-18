class Public::JournalsController < ApplicationController
  layout "public"

  # GET /public/journals
  # GET /public/journals.json

  def index
    @journals = Journal.order(:title).page(params[:page])
  end

  # GET /public/journals/1
  # GET /public/journals/1.json
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@journals)
    @journal = Journal.find(params[:id])
    @referenced_texts = Text.where(:journal_id => @journal.id)
  end
end
