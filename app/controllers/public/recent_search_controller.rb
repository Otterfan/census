class Public::RecentSearchController < ApplicationController
  layout 'public'

  def index
    puts 'SESSION ID'
    puts session.id
    @searches = RecentSearch.where(:session_id => session.id.to_s).page(params[:page]).per(15)
  end
end
