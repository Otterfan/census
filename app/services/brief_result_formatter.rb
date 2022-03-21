class BriefResultFormatter
  include TextsHelper

  def initialize(used_params, fields_in_view, query_params)
    @used_params = used_params
    @fields_in_view = fields_in_view
    @search_terms = @used_params.map {|val| query_params[val]}
    puts @search_terms
  end

  def format(value)
    value = convert_underscores(value)
    singularized_terms = @search_terms.map {|x| ActiveSupport::Inflector.singularize(x)}
    unless @search_terms.empty?
      value = highlight_search_results(singularized_terms, value)
    end
    value
  end

  private

  def highlight_search_results(singularized_terms, value)
    highlight_regex = singularized_terms.join('|')
    ActionController::Base.helpers.highlight(value, /#{Regexp.escape(highlight_regex)}/i)
  end
end