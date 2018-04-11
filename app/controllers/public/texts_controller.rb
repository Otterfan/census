class Public::TextsController < ApplicationController
  layout "public"

  before_action :authenticate_user!\

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
    @text = Text.find_by_census_id(params[:id])
  end
end
