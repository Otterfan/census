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

      query_string_array = []

      @facets = {}

      # define the fields that a keyword search will query
      # complex associated models use dot notation, e.g., publication_places.place.name
      if params[:keyword].present?
        query_string_array << {
            query_string: {
                fields: %w{
                  title
                  original
                  original_greek_title
                  date
                  genre
                  material_type
                  text_type
                  journal.title
                  publisher
                  other_text_languages.language.name
                  publication_places.place.name
                  topic_author.full_name
                  topic_author.alternate_name
                  text_citations.name
                  components.title
                  components.component_citations.name
                },
                type: "best_fields",
                query: sanitize_query(params[:keyword])
            }
        }
      end

      # advanced search fields

      if params[:title].present?
        query_string_array << {
            query_string: {
                fields: ['title'],
                query: sanitize_query(params[:title])
            }
        }
      end

      if params[:journal].present?
        query_string_array << {
            query_string: {
                fields: ['journal.title'],
                query: sanitize_query(params[:journal])
            }
        }
      end

      if params[:location].present?
        query_string_array << {
            query_string: {
                fields: ['publication_places.place.name'],
                query: sanitize_query(params[:location])
            }
        }
      end

      # the 'people' form field queries several different fields
      if params[:people].present?
        query_string_array << {
            query_string: {
                fields: %w{
                  text_citations.name
                  components.component_citations.name
                  topic_author.full_name
                },
                query: sanitize_query(params[:people])
            }
        }
      end

      if params[:component_title].present?
        query_string_array << {
            query_string: {
                fields: ['components.title'],
                query: sanitize_query(params[:component_title])
            }
        }
      end


      # facet filter fields

      if params[:genre].present?
        @facets["genre"] = params[:genre]
        query_string_array << {
            query_string: {
                fields: ['genre'],
                query: wrap_in_quotes(sanitize_query(params[:genre]))
            }
        }
      end

      if params[:material_type].present?
        @facets["material_type"] = params[:material_type]
        query_string_array << {
            query_string: {
                fields: ['material_type'],
                query: wrap_in_quotes(sanitize_query(params[:material_type]))
            }
        }
      end

      if params[:text_type].present?
        @facets["text_type"] = params[:text_type]
        query_string_array << {
            query_string: {
                fields: ['text_type'],
                query: wrap_in_quotes(sanitize_query(params[:text_type]))
            }
        }
      end

      if params[:topic_author].present?
        @facets["topic_author"] = params[:topic_author]
        query_string_array << {
            query_string: {
                fields: ['topic_author.full_name'],
                query: wrap_in_quotes(sanitize_query(params[:topic_author]))
            }
        }
      end

      if params[:publication_places].present?
        @facets["publication_places"] = params[:publication_places]
        query_string_array << {
            query_string: {
                fields: ['publication_places.place.name'],
                query: wrap_in_quotes(sanitize_query(params[:publication_places]))
            }
        }
      end

      if params[:other_text_languages].present?
        @facets["other_text_languages"] = params[:other_text_languages]
        query_string_array << {
            query_string: {
                fields: ['other_text_languages.language.name'],
                query: wrap_in_quotes(sanitize_query(params[:other_text_languages]))
            }
        }
      end

      # create Elasticsearch search query
      # add in aggregated fields (facets) here
      all_search = {
          query: {
              bool: {
                  must: query_string_array
              }
          },
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
end


