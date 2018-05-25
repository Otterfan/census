class Public::RecentSearchController < ApplicationController
  layout 'public'

  def index
    @searches = []
    saved_searches = session[:recent_searches]
    num = 1

    hour_format = '%Y-%m-%d %H:%M'

    saved_searches.each do |search|
      puts search
      search_time = search['timestamp'].to_datetime.strftime(hour_format)
      @searches << {
          num: num,
          query: build_query(search['params']),
          display: search_display_string(search["params"]),
          type: search_type(search['params']),
          time: search_time
      }
      num = num + 1
    end
    @searches.reverse!
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

  def search_type(saved_search)
    saved_search.key?('bq') ? 'advanced' : 'keyword'
  end
end
