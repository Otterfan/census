class TextsController < ApplicationController
  layout "public"

  include TextsHelper

  # GET /public/texts
  def index
    @results_formatter = BriefResultFormatter.new([],[],[])
    @texts = Text.includes(:topic_author).where.not(is_hidden: true).order("people.sort_full_name asc, sort_census_id asc").page(params[:page])

    if params[:sort] == "author"
      @sorted = "author"
    else
      @sorted = "title"
    end
  end

  # GET /texts/1 or
  # GET /texts/4.1234
  def show
    if params[:census_id] || params[:id].include?("4.")
      @text = Text.find_by_census_id(params[:census_id])
    else
      @text = Text.find(params[:id])
    end

    if @text.is_hidden
      unless user_signed_in? && current_user.user_type != 'viewer'
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end
