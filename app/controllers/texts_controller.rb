class TextsController < ApplicationController
  layout "public"

  before_action :authenticate_user!\

  include TextsHelper

  # GET /public/texts
  def index
    @results_formatter = BriefResultFormatter.new([],[],[])
    @texts = Text.order(:topic_author_id, :sort_census_id).page(params[:page])

    if params[:sort] == "author"
      @sorted = "author"
    else
      @sorted = "title"
    end
  end

  # GET /texts/1 or
  # GET /texts/4.1234
  def show
    if params[:census_id]
      @text = Text.find_by_census_id(params[:census_id])
    else
      @text = Text.find(params[:id])
    end
  end
end
