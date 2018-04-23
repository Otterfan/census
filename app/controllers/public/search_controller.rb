class Public::SearchController < ApplicationController
  layout "public"
  include Public::TextsHelper

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
      :other_text_languages,
      :publication_date_range,
      :bq
  ]

  DEFAULT_VIEW_PARAMS = [
      :title,
      :topic_author
  ]

  # the 'people' form field queries several different fields
  PEOPLE_FIELDS = %w{
      text_citations.name
      components.component_citations.name
      topic_author.full_name
  }

  ADVANCED_SEARCH_FIELDS = [
      :keyword,
      :title,
      :journal,
      :location,
      :component_title,
      :people,
      :volume,
      :topic_author,
      :citation_name,
      :component_citation_name,
      :text_type,
      :material_type,
      :genre,
      :original_greek_title,
      :original_greek_place_of_publication,
      :original_greek_publisher,
      :original_greek_collection,
      :publisher,
      :source,
      :census_id,
      :series,
      :sponsoring_organization,
      :issue_title,
      :issue_editor,
      :authors_name_from_source,
      :standard_numbers,
      :collection
  ]

  CONTROLLED_VOCAB_SEARCH_FIELDS = [
      :text_type,
      :material_type,
      :genre
  ]

  BOOLEAN_OPERATORS = [
      :and,
      :or,
      :not
  ]

  FACET_HITS_SIZE = 100

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

  # Generate the search string used for keyword searching
  def generate_keyword_search_array(kw_param)
    # define the fields that a keyword search will query
    # complex associated models use dot notation, e.g., publication_places.place.name
    @kw_query_string_array = []
    if kw_param.present?
      @kw_query_string_array << {
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
                  title.trim_underscores^5
                  title.folded^5
                  title.el^5
                  components.title^5
                  components.title.folded^5
                  components.title.el^5
                  components.genre
                  components.text_type
                  components.collection
                  components.collection.folded
                  components.collection.el
                  components.note
                  components.note.folded
                  components.note.el
                  text_type
                  sort_date
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
                  source
                  source.folded
                  source.el
                  note
                  note.folded
                  note.el
                  census_id
                  series
                  series.folded
                  series.el
                  original_greek_place_of_publication
                  original_greek_place_of_publication.el
                  original_greek_publisher
                  original_greek_publisher.el
                  original_greek_date
                  sponsoring_organization
                  sponsoring_organization.folded
                  sponsoring_organization.el
                  special_location_of_item
                  special_source_of_info
                  special_source_of_info.folded
                  special_source_of_info.el
                  issue_editor
                  issue_editor.el
                  issue_title
                  issue_title.el
                  abstract
                  abstract.el
                  authors_name_from_source
                  authors_name_from_source.el
                  editorial_annotation
                  editorial_annotation.folded
                  editorial_annotation.el
                  original_greek_collection
                  original_greek_collection.el
                  collection
                  collection.el
                  volume.title
                  volume.title.folded
                  volume.title.el
                  standard_numbers.value
                },
              lenient: true,
              type: "most_fields",
              default_operator: "and",
              query: sanitize_query(kw_param)
          }
      }

      puts "keyword search array: "
      puts @kw_query_string_array

      @kw_query_string_array
    end
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

    # get unique values for adv search drop downs
    @unique_values = {}
    CONTROLLED_VOCAB_SEARCH_FIELDS.each do |field|
      field_s = field.to_s
      uniq_vals = Text.get_unique_values(field_s)

      # text_type field requires some label editing
      if field_s == "text_type"
        mapped_uniq_vals = uniq_vals.map {|v| [format_label(v), v]}
        @unique_values[field_s] = mapped_uniq_vals
      else
        @unique_values[field_s] = uniq_vals
      end
    end

    if is_search?
      @query_hash = {}
      @query_string_array = []
      @facets = {}

      if @search_type == "adv"
        # process_adv_search method can raise ArgumentError
        begin
          @res = process_adv_search
          @query_hash[:must] = @res
        rescue ArgumentError => e
          puts "Caught error: " + e.message
          return nil
        end
      else
        # add the keyword field
        @query_string_array << generate_keyword_search_array(params[:keyword])
        # facet filter fields
        add_facet_search(['genre'], :genre)
        add_facet_search(['material_type'], :material_type)
        add_facet_search(['text_type'], :text_type)
        add_facet_search(['topic_author.full_name'], :topic_author)
        add_facet_search(['publication_places.place.name'], :publication_places)
        add_facet_search(['other_text_languages.language.name'], :other_text_languages)
        add_facet_search_date_range('publication_date_range', :publication_date_range)

        @query_hash[:must] = @query_string_array
      end

      # create Elasticsearch search query
      # add in aggregated fields (facets) here
      all_search = {
          query: {
              bool: @query_hash
          },
          sort: query_sort(params[:sort]),
          highlight: {
              fields: highlight_fields
          },
          aggs: {
              genre: {
                  terms: {
                      field: "genre.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
              "material_type": {
                  terms: {
                      field: "material_type.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
              "text_type": {
                  terms: {
                      field: "text_type.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
              "topic_author": {
                  terms: {
                      field: "topic_author.full_name.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
              "publication_places": {
                  terms: {
                      field: "publication_places.place.name.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
              "other_text_languages": {
                  terms: {
                      field: "other_text_languages.language.name.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
              "publication_dates": {
                  date_histogram: {
                      field: "sort_date",
                      interval: "year",
                      format: "yyyy",
                      # missing: "1900"
                  }
              }
          }
      }

      query_result = Text.search(all_search).page(params[:page]).per(@pagination_page_size)
      @aggregations = query_result.aggregations
      @publication_dates = get_date_range_data(query_result.aggregations)

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

  # processes raw boolean search query string
  def process_adv_search
    @combined_query_list = []

    # example of raw combined bool search query string
    # bq=(title+cats paw)++OR++(people+jack)++NOT++(component_title+fish)
    #
    # Rails will sanitize string by replacing all "+" symbols into spaces
    # bq=(title cats paw)  OR  (people jack)  NOT  (component_title fish)

    # simple sanity checking
    # check that the first and last characters in the search string are parenthesis
    if params[:bq][0] != "(" or params[:bq][-1] != ")"
      raise ArgumentError.new("The advanced search query is malformed.")
    end

    # First, split query string by double spaces to get tokens like:
    # [0] (title cats paw)
    # [1] OR
    # [2] (people jack)
    # [3] NOT
    # [4] (component_title fish)
    #
    # NB There is a pattern where boolean operators are on odd-numbered indices
    #    and the fields & values are on even-numbered indices. There will always
    #    be an odd number of indices with this pattern.

    tokens = params[:bq].split("--")

    puts "tokens:"
    puts tokens

    # simple sanity checking
    # we always expect an odd number of tokens
    if tokens.length.even?
      raise ArgumentError.new("The advanced search query has an unexpected number of tokens: " + tokens.length.to_s)
    end

    # regular expression used to match the field name and search string from the combined bool search query
    match_re = /\((\w+)::([^)]+)\)/i

    # Next, process each type of token by even- and odd-numbered indexes
    tokens.each_with_index do |tok, i|
      if i.modulo(2).even?
        # get even numbered tokens
        #
        # (field_name::search_string)

        field_tokens = match_re.match(tok)

        puts "field_tokens:"
        puts field_tokens

        # we know that we should only match two elements with our regex: a field name and search string
        if field_tokens
          if field_tokens.length >= 2
            field_name = field_tokens[1]
            search_string = field_tokens[2]

            puts "found field name   : " + field_name
            puts "found search string: " + search_string

            trimmed_search_string = search_string.strip
            clean_search_string = wrap_in_quotes(sanitize_query(trimmed_search_string))

            puts "cleaned search string: " + clean_search_string

            # make sure we're only processing advanced search fields we know.
            # query strings will be added to @combined_query_list list object
            if search_string and ADVANCED_SEARCH_FIELDS.include? field_name.to_sym
              case field_name
              when "keyword"
                @combined_query_list << generate_keyword_search_array(clean_search_string)
              when "title"
                add_field_adv_search_multiple(['title', 'title.trim_underscores', 'title.folded', 'title.el'], clean_search_string)
              when "journal"
                add_field_adv_search_multiple(['journal.title', 'journal.title.folded', 'journal.title.el'], clean_search_string)
              when "location"
                add_field_adv_search_multiple(['publication_places.place.name', 'publication_places.place.name.folded', 'publication_places.place.name.el'], clean_search_string)
              when "component_title"
                add_field_adv_search_multiple(['components.title', 'components.title.folded', 'components.title.el'], clean_search_string)
              when "people"
                add_field_adv_search_multiple(PEOPLE_FIELDS, clean_search_string)
              when "topic_author"
                add_field_adv_search_multiple(['topic_author.full_name', 'topic_author.full_name.folded', 'topic_author.full_name.el'], clean_search_string)
              when "citation_name"
                add_field_adv_search_multiple(['text_citations.name', 'text_citations.name.folded', 'text_citations.name.el'], clean_search_string)
              when "component_citation_name"
                add_field_adv_search_multiple(['components.component_citations.name', 'components.component_citations.name.folded', 'components.component_citations.name.el'], clean_search_string)
              when "volume"
                add_field_adv_search_multiple(['volume.title', 'volume.title.folded', 'volume.title.el'], clean_search_string)
              when "text_type"
                add_field_adv_search(['text_type'], clean_search_string)
              when "material_type"
                add_field_adv_search(['material_type'], clean_search_string)
              when "genre"
                add_field_adv_search(['genre'], clean_search_string)
              when "original_greek_title"
                add_field_adv_search_multiple(['original_greek_title', 'original_greek_title.el'], clean_search_string)
              when "original_greek_place_of_publication"
                add_field_adv_search_multiple(['original_greek_place_of_publication', 'original_greek_place_of_publication.el'], clean_search_string)
              when "original_greek_publisher"
                add_field_adv_search_multiple(['original_greek_publisher', 'original_greek_publisher.el'], clean_search_string)
              when "original_greek_collection"
                add_field_adv_search_multiple(['original_greek_collection', 'original_greek_collection.el'], clean_search_string)
              when "publisher"
                add_field_adv_search_multiple(['publisher', 'publisher.folded', 'publisher.el'], clean_search_string)
              when "source"
                add_field_adv_search_multiple(['source', 'source.folded', 'source.el'], clean_search_string)
              when "census_id"
                add_field_adv_search(['census_id'], clean_search_string)
              when "series"
                add_field_adv_search_multiple(['series', 'series.folded', 'series.el'], clean_search_string)
              when "sponsoring_organization"
                add_field_adv_search_multiple(['sponsoring_organization', 'sponsoring_organization.folded', 'sponsoring_organization.el'], clean_search_string)
              when "issue_title"
                add_field_adv_search_multiple(['issue_title', 'issue_title.el'], clean_search_string)
              when "issue_editor"
                add_field_adv_search_multiple(['issue_editor', 'issue_editor.el'], clean_search_string)
              when "authors_name_from_source"
                add_field_adv_search_multiple(['authors_name_from_source', 'authors_name_from_source.el'], clean_search_string)
              when "standard_numbers"
                add_field_adv_search(['standard_numbers.value'], clean_search_string)
              when "collection"
                add_field_adv_search_multiple(['collection', 'collection.el'], clean_search_string)
              else

              end
            end
          else
            # in this case we only have a field name but no corresponding search string.
            # this ignores the case where we have at least one valid field name and search string pair.
            raise ArgumentError.new("The advanced search query is missing the search string.")
          end
        end

      else
        # get odd numbered tokens
        # boolean tokens
        if BOOLEAN_OPERATORS.include? tok.downcase.to_sym
          # TODO
        else
          raise ArgumentError.new("The advanced search query has an unknown boolean operator: " + tok)
        end
      end
    end

    puts "updated combined_query_list:"
    puts @combined_query_list

    @combined_query_list
  end

  def get_date_range_data(aggs)
    dates_json = []
    if aggs["publication_dates"]["buckets"].present?
      dates = aggs["publication_dates"]["buckets"]
      # puts dates

      dates.each do |date|
        # puts date.key_as_string
        if date.doc_count > 0
          dates_json << {"value": date.key_as_string.to_i, "count": date.doc_count}
        end
      end

      dates_json.to_json
    else
      dates_json.to_json
    end
  end

  def search_params
    params.permit(:keyword, :title, :journal, :location, :people, :type, :component_title,
                  :genre, :material_type, :text_type, :topic_author, :publication_places, :other_text_languages,
                  :publication_date_range, :bq)
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

  def add_facet_search_date_range(field, param)
    add_field_search_date_range(field, param, true)
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

  # Advanced search. Add a search on a specific field to the string array
  def add_field_adv_search(fields, field_val)
    fields.each do |field|
      @combined_query_list << {
          match: {
              field => field_val
          }
      }
    end

    # must: [{
    #       match: {
    #           field => field_val
    #       }
    #   },
    #   {
    #       match: {
    #           field => field_val
    #       }
    # }]
  end

  # Advanced search. Add a search on a select fields to the string array
  def add_field_adv_search_multiple(fields, field_val)
    @should_list = []
    fields.each do |field|
      @should_list << {
          match: {
              field => field_val
          }
      }
    end

    @combined_query_list << {
        bool: {
          should: @should_list
        }
    }

    # must: [{
    #     bool: {
    #         should: [{
    #             match: {
    #                 field1 => field_val
    #             }
    #         },
    #         {
    #             match: {
    #                 field2 => field_val
    #             }
    #         }]
    #     }
    # }]
  end

  # Add a date range search
  def add_field_search_date_range(field, param, is_facet=false)
    if params[param].present?
      # check that we have a four-digit year, a dash, and a four-digit year for date range param
      check_year_regex = /^\d{4}-\d{4}$/
      if check_year_regex.match(params[param])
        dates = params[param].split("-")

        # we expect only two values in the dates array
        if dates.length == 2
          if is_facet
            @facets[field] = params[param]
          end

          @publication_date_range_earliest = dates[0]
          @publication_date_range_latest = dates[1]

          @query_string_array << {
              range: {
                  "sort_date": {
                      gte: @publication_date_range_earliest,
                      lte: @publication_date_range_latest,
                      format: "yyyy"
                  }
              }
          }
        else
          params[param] = nil
          nil
        end
      else
        # date range params didn't pass our regex so clear them out
        params[param] = nil
        nil
      end
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