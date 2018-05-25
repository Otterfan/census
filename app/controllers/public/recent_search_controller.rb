class Public::RecentSearchController < ApplicationController
  layout 'public'

  def index
    @searches = []
    saved_searches = session[:recent_searches]
    saved_searches.reverse_each do |search|
      @searches << {query: build_query(search), display: search_display_string(search)}
    end
  end

  private

  def build_query(saved_search)
    saved_search['utf8'] = '✓'
    saved_search['type'] = saved_search.key?('bq') ? 'adv' : 'kw'
    saved_search.to_a.reverse.to_h
  end

  def search_display_string(saved_search)
    saved_search.key?('bq') ? search_val = saved_search['bq'] : search_val = saved_search['keyword']
    search_val.gsub('--', ' ')
  end
end
