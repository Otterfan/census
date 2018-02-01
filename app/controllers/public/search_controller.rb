class Public::SearchController < ApplicationController
  layout "public"

  # GET /public/search
  # GET /public/search.json ???
  def index
    if params[:keyword] && params[:keyword].present?
      # @texts = Text.where('original LIKE ?', "%#{params[:keyword]}%")
      @texts = Text.search(params[:keyword])
    else
      @texts = Text.none
    end
  end

  private
  def search_params
    params.require(:keyword).permit(:title, :location, :people, :journal, )
  end
end
