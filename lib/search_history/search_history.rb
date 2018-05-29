module SearchHistory
  class HistoryManager
    def initialize(session_id)
      @session_id = session_id
    end

    def add(params)
      search = RecentSearch.new
      search.session_id=@session_id
      search.parameters = params
      search.type='???'
    end
  end
end