class Public::TextsController < ApplicationController
  layout "public"

  before_action :authenticate_user!\

  # GET /public/texts
  def index
    @results_formatter = BriefResultFormatter.new([],[],[])
    @texts = Text.order(:sort_census_id).page(params[:page])

    if params[:sort] == "author"
      @sorted = "author"
    else
      @sorted = "title"
    end
  end

  # GET /public/texts/1
  def show
    @text = Text.find(params[:id])
  end
end
