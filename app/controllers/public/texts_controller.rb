class Public::TextsController < ApplicationController
  layout "public"

  # GET /public/texts
  # GET /public/texts.json
  def index
    @texts = Text.order(:id).page(params[:page])

    if params[:sort] == "author"
      @sorted = "author"
    else
      @sorted = "title"
    end
  end

  # GET /public/texts/1
  # GET /public/texts/1.json
  def show
    #redirect_to texts_path(@texts)
    @text = Text.find(params[:id])
  end
end
