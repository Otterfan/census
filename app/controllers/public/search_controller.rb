class Public::SearchController < ApplicationController
  layout "public"

  before_action :authenticate_user!

  SEARCH_PARAMS = [
      :keyword,
      :title,
      :journal,
      :location,
      :people,
      :component_title,
      :genre,
      :material_type,
      :text_type,
      :topic_author,
      :publication_places,
      :other_text_languages
  ]

  DEFAULT_VIEW_PARAMS = [
      :title,
      :topic_author
  ]

  # https://stackoverflow.com/questions/16205341/symbols-in-query-string-for-elasticsearch
  def sanitize_query(str)
    # Escape special characters
    # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#_regular_expressions
    escaped_characters = Regexp.escape('\\/+-&|!(){}[]^~*?:')
    str = str.gsub(/([#{escaped_characters}])/, '\\\\\1')

    # AND, OR and NOT are used by lucene as logical operators. We need
    # to escape them
    ['AND', 'OR', 'NOT'].each do |word|
      escaped_word = word.split('').map {|char| "\\#{char}"}.join('')
      str = str.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
    end

    # Escape odd quotes
    quote_count = str.count '"'
    str = str.gsub(/(.*)"(.*)/, '\1\"\3') if quote_count % 2 == 1

    str
  end

  # facet fields need to be wrapped in double quotes to avoid implicit OR'ing
  def wrap_in_quotes(str)
    unless str
      return str
    end

    %Q("#{str}")
  end

  # GET /public/search
  def search
    # set the number of results per page for this specific search controller.
    # this overrides the paginates_per variable in the Text model
    @pagination_page_size = 10

    if params[:type] == "adv"
      @search_type = "adv"
    else
      @search_type = "kw"
    end

    if is_search?

      @query_string_array = []

      @facets = {}

      # define the fields that a keyword search will query
      # complex associated models use dot notation, e.g., publication_places.place.name
      if params[:keyword].present?
        @query_string_array << {
            query_string: {
                fields: %w{
                  topic_author.full_name^10
                  topic_author.full_name.folded^10
                  topic_author.full_name.el^10
                  topic_author.alternate_name^10
                  topic_author.alternate_name.folded^10
                  topic_author.alternate_name.el^10
                  text_citations.name^10
                  text_citations.name.folded^10
                  text_citations.name.el^10
                  components.component_citations.name^10
                  components.component_citations.name.folded^10
                  components.component_citations.name.el^10
                  title^5
                  title.folded^5
                  title.el^5
                  components.title^5
                  components.title.folded^5
                  components.title.el^5
                  text_type
                  date
                  original_greek_title
                  original_greek_title.folded
                  original_greek_title.el
                  genre
                  publication_places.place.name
                  publication_places.place.name.folded
                  publication_places.place.name.el
                  publisher
                  publisher.folded
                  publisher.el
                  journal.title
                  journal.title.folded
                  journal.title.el
                  material_type
                  other_text_languages.language.name
                  other_text_languages.language.name.folded
                  original
                  original.folded
                  original.el
                },
                type: "most_fields",
                default_operator: "and",
                query: sanitize_query(params[:keyword])
            }
        }
      end

      # advanced search fields
      add_field_search(['title'], :title)
      add_field_search(['journal.title'], :journal)
      add_field_search(['publication_places.place.name'], :location)
      add_field_search(['components.title'], :component_title)

      # the 'people' form field queries several different fields
      people_fields = %w{
                  text_citations.name
                  components.component_citations.name
                  topic_author.full_name
                }
      add_field_search(people_fields, :people)

      # facet filter fields
      add_facet_search(['genre'], :genre)
      add_facet_search(['material_type'], :material_type)
      add_facet_search(['text_type'], :text_type)
      add_facet_search(['topic_author.full_name'], :topic_author)
      add_facet_search(['publication_places.place.name'], :publication_places)
      add_facet_search(['other_text_languages.language.name'], :other_text_languages)

      # create Elasticsearch search query
      # add in aggregated fields (facets) here
      all_search = {
          query: {
              bool: {
                  must: @query_string_array
              }
          },
          sort: query_sort(params[:sort]),
          highlight: {
              fields: highlight_fields
          },
          aggs: {
              genre: {
                  terms: {
                      field: "genre.keyword"
                  }
              },
              "material_type": {
                  terms: {
                      field: "material_type.keyword"
                  }
              },
              "text_type": {
                  terms: {
                      field: "text_type.keyword"
                  }
              },
              "topic_author": {
                  terms: {
                      field: "topic_author.full_name.keyword"
                  }
              },
              "publication_places": {
                  terms: {
                      field: "publication_places.place.name.keyword"
                  }
              },
              "other_text_languages": {
                  terms: {
                      field: "other_text_languages.language.name.keyword"
                  }
              }
          }
      }

      query_result = Text.search(all_search).page(params[:page]).per(@pagination_page_size)
      @aggregations = query_result.aggregations
      @texts = query_result.results
      @results_formatter = BriefResultFormatter.new(used_params, DEFAULT_VIEW_PARAMS, params)

    else
      @new_search = true
      @texts = []
    end
    @sort_options = [
        ['Relevance', 'score'],
        ['Date (oldest first)', 'date-oldest-first'],
        ['Date (newest first)', 'date-newest-first']
    ]
  end

  private
  def search_params
    params.permit(:keyword, :title, :journal, :location, :people, :type, :component_title,
                  :genre, :material_type, :text_type, :topic_author, :publication_places, :other_text_languages)
  end

  # Return a list of all symbols of search parameters used in the current request
  def used_params
    SEARCH_PARAMS.reject {|key| !params[key].present?}
  end

  # Return true if this is a search request
  def is_search?
    puts used_params
    used_params.length > 0
  end

  # Build ES highlight fields for search fields not used in the view
  def highlight_fields
    fields_to_highlight = SEARCH_PARAMS - used_params
    fields_obj = {}
    fields_to_highlight.each {|field| fields_obj[field] = {}}
    fields_obj
  end

  # Add a search on a facet to the query string array
  def add_facet_search(fields, param)
    add_field_search(fields, param, true)
  end

  # Add a search on a specific field to the string array
  def add_field_search(fields, param, is_facet = false)
    if params[param].present?
      if is_facet
        @facets[param] = params[param]
      end
      @query_string_array << {
          query_string: {
              fields: fields,
              query: wrap_in_quotes(sanitize_query(params[param]))
          }
      }
    end
  end

  # Build the query's sort clause
  def query_sort(sort_type)
    case sort_type
      when 'date-oldest-first'
        [{sort_date: {order: 'asc'}}, '_score']
      when 'date-newest-first'
        [{sort_date: {order: 'desc'}}, '_score']
      else
        ['_score']
    end
  end
end