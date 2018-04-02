class BriefResultFormatter
  def initialize(used_params, fields_in_view, query_params)
    puts 'INITIALIZED'
    @used_params = used_params
    @fields_in_view = fields_in_view
    @search_terms = @used_params.map {|val| query_params[val]}
    puts @search_terms
  end

  def format(value)
    underscores_converted = Public::TextsController.helpers.convert_underscores(value)
    highlight_regex = @search_terms.join('|')
    ActionController::Base.helpers.highlight(underscores_converted, /#{highlight_regex}/i)
  end

  private
end