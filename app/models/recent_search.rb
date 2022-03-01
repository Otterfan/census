class RecentSearch < ApplicationRecord
  self.inheritance_column = 'column_that_is_not_type'

  default_scope {order(updated_at: :desc)}

  def self.add(session_id, parameters)
    params_string = RecentSearch::extract_params(parameters)
    previous_search = RecentSearch.find_by(session_id: session_id, parameters: params_string)

    if previous_search
      previous_search.touch
    else

      search = RecentSearch.new
      search.session_id = session_id

      if parameters.key?('bq')
        search.parameters = parameters['bq']
        search.type = 'advanced'
      else
        search.parameters = parameters['keyword']
        search.type = 'basic'
      end

      search.save

    end
  end

  def time
    hour_format = '%Y-%m-%d %H:%M'
    updated_at.to_datetime.strftime(hour_format)
  end

  def display
    if parameters
      parameters.gsub('--', ' ')
    end
  end

  def query_string
    query = {}
    if type == 'basic'
      query['keyword'] = parameters
      query['type'] = 'kw'
    else
      query['bq'] = parameters
      query['type'] = 'adv'
    end
    query['utf8'] = '✓'
    query
  end

  private

  def self.extract_params(parameters)
    if parameters.key?('bq')
      parameters['bq']
    else
      parameters['keyword']
    end
  end

  def self.determine_type(parameters)
    parameters.key?('bq') ? 'advanced' : 'basic'
  end

  def self.build_query(paramters, session_id)

  end

end
