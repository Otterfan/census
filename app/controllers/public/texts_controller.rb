class Public::TextsController < ApplicationController
  layout "public"

  # GET /public/texts
  def index
    @texts = Text.order(:sort_id).page(params[:page])

    if params[:sort] == "author"
      @sorted = "author"
    else
      @sorted = "title"
    end
  end

  # GET /public/texts/1
  def show
    #redirect_to texts_path(@texts)
    @text = Text.find(params[:id])
  end
end
