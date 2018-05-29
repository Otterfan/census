class Public::RecentSearchController < ApplicationController
  layout 'public'

  def index
    @searches = RecentSearch.where(:session_id => session.id).page(params[:page]).per(15)
  end
end
