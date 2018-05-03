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

  KEYWORD_FIELDS = %w{
    census_id.exact
    text_type.exact^5
    material_type.exact

    topic_author.full_name^10
    topic_author.full_name.en_folded^10
    topic_author.full_name.el_folded^10
    topic_author.alternate_name^10
    topic_author.alternate_name.en_folded^10
    topic_author.alternate_name.el_folded^10

    authors_name_from_source
    authors_name_from_source.el_folded
    authors_name_from_source.en_folded

    title^10
    title.en_folded^10
    title.el_folded^10
    sort_title^10
    sort_title.en_folded^10
    sort_title.el_folded^10

    text_citations.name^10
    text_citations.name.en_folded^10
    text_citations.name.el_folded^10
    text_citations.role.exact^5
    volume.title^5
    volume.title.en_folded^5
    volume.title.el_folded^5
    volume.sort_title^5
    volume.sort_title.en_folded^5
    volume.sort_title.el_folded^5
    series
    series.en_folded
    series.el_folded

    publication_places.place.name
    publication_places.place.name.en_folded
    publication_places.place.name.el_folded
    publisher
    publisher.en_folded
    publisher.el_folded

    sort_date

    components.title^5
    components.title.en_folded^5
    components.title.el_folded^5
    components.genre
    components.text_type
    components.collection
    components.collection.en_folded
    components.collection.el_folded
    components.note
    components.note.en_folded
    components.note.el_folded

    genre.exact^5

    url

    journal.title^5
    journal.title.en_folded^5
    journal.title.el_folded^5
    journal.sort_title^5
    journal.sort_title.en_folded^5
    journal.sort_title.el_folded^5

    sponsoring_organization
    sponsoring_organization.en_folded
    sponsoring_organization.el_folded

    collection
    collection.en_folded
    collection.el_folded

    standard_numbers.value.exact
    dai.exact

    components.component_citations.name^10
    components.component_citations.name.en_folded^10
    components.component_citations.name.el_folded^10
    components.component_citations.genre.exact^5
    components.component_citations.text_type.exact
    components.component_citations.collection^10
    components.component_citations.collection.en_folded^10
    components.component_citations.collection.el_folded^10

    note
    note.en_folded
    note.el_folded
    abstract
    abstract.en_folded
    abstract.el_folded
    editorial_annotation
    editorial_annotation.en_folded
    editorial_annotation.el_folded
    physical_description
    physical_description.en_folded
    physical_description.el_folded

    source
    source.en_folded
    source.el_folded
    original_greek_title^10
    original_greek_title.el_folded^10
    original_greek_collection
    original_greek_collection.el_folded
    original_greek_place_of_publication
    original_greek_place_of_publication.el_folded
    original_greek_publisher
    original_greek_publisher.el_folded
    original_greek_date^5

    other_text_languages.language.name
    other_text_languages.language.name.exact

    special_location_of_item
    special_location_of_item.en_folded
    special_location_of_item.el_folded
    special_source_of_info
    special_source_of_info.en_folded
    special_source_of_info.el_folded

    cross_references.census_id.exact

    original
    original_clean
    original_clean.el_folded
    original_clean.en_folded
  }


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

  # Generate @kw_query_string_hash hash for keyword searching
  def generate_keyword_search_array(kw_param)
    # define the fields that a keyword search will query.
    # complex associated models use dot notation, e.g., publication_places.place.name
    @kw_query_string_hash = {}
    if kw_param.present?
      @kw_query_string_hash = {
          query_string: {
              fields: KEYWORD_FIELDS,
              lenient: true,
              type: "most_fields",
              default_operator: "and",
              query: sanitize_query(kw_param)
          }
      }

      puts "  keyword search hash  : #{@kw_query_string_hash}"

      @kw_query_string_hash
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
        # process_adv_search method can raise ArgumentError.
        # process_adv_search method returns two array, one for Elasticsearch "must",
        # and another for "must_not". The former only applies to keyword search with a NOT bool operator
        begin
          @results = process_adv_search
          @query_array = @results
        rescue ArgumentError => e
          puts "Caught error: " + e.message
          return nil
        end
      else
        # add the keyword hash to @query_string_array
        @query_string_array << generate_keyword_search_array(params[:keyword])

        # facet filter fields
        # the add_facet_search method will add in a query_string hash to the @query_string_array array
        add_facet_search(['genre'], :genre)
        add_facet_search(['material_type'], :material_type)
        add_facet_search(['text_type'], :text_type)
        add_facet_search(['topic_author.full_name'], :topic_author)
        add_facet_search(['publication_places.place.name'], :publication_places)
        add_facet_search(['other_text_languages.language.name'], :other_text_languages)
        add_facet_search_date_range('publication_date_range', :publication_date_range)

        @query_array = @query_string_array
      end

      # create Elasticsearch search query using the @query_array list we've been constructing.
      # add in aggregated fields (facets), highlighting and sort configuration here
      @all_search = {
          query: {
              bool: {}
          },
          sort: query_sort(params[:sort]),
          highlight: {
              #fields: highlight_fields
              fragment_size: "90",
              pre_tags: ["<mark>"],
              post_tags: ["</mark>"],
              fields: [
                  {
                      "original_clean": {
                          matched_fields: ["original_clean", "original_clean.en_folded", "original_clean.el_folded"],
                          force_source: :true,
                          type: :fvh
                      }
                  }, {
                    "original": {
                        matched_fields: ["original", "original.en_folded", "original.el_folded"],
                        force_source: :true,
                        type: :fvh
                    }
                }
              ]
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

      # add in the @query_array array elements to the "must" query block
      if @query_array.length > 0
        @all_search[:query][:bool][:must] = @query_array
      end

      query_result = Text.search(@all_search).page(params[:page]).per(@pagination_page_size)
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
        ['Title','sort-title'],
        ['Date (oldest first)', 'date-oldest-first'],
        ['Date (newest first)', 'date-newest-first']
    ]
  end

  private

  # processes raw boolean search query string
  def process_adv_search
    @combined_query_string = []
    @keyword_query_hash = {}
    @adv_search_array = []
    @filter_hash = {}
    @current_bool_op = "AND"

    # create the query_string hash
    @combined_query_hash = {}
    @combined_query_hash[:query_string] = {}

    # example of raw combined bool search query string
    # bq=(title+cats paw)++OR++(people+jack)++NOT++(component_title+fish)
    #
    # Rails will sanitize string by replacing all "+" symbols into spaces
    # bq=(title cats paw)  OR  (people jack)  NOT  (component_title fish)

    # simple sanity checking
    # check that the first and last characters in the search string are parentheses
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

    puts "\nList of tokens in ADVANCED search:"
    tokens.each_with_index  do |t,i|
      puts "  [#{i}] #{t}"
    end

    # simple sanity checking
    # we always expect an odd number of tokens
    if tokens.length.even?
      raise ArgumentError.new("The advanced search query has an unexpected number of tokens: " + tokens.length.to_s)
    end

    # regular expression used to match the field name and search string from the combined bool search query
    match_re = /\((\w+)::([^)]+)\)/i

    # Next, process each type of token by even- and odd-numbered indexes
    tokens.each_with_index do |tok, i|
      puts "\nLooking at token [#{i}]: #{tok}"
      if i.modulo(2).even?
        # get even numbered tokens
        #
        # (field_name::search_string)

        field_tokens = match_re.match(tok)

        # we know that we should only match two elements with our regex: a field name and search string
        if field_tokens
          if field_tokens.length >= 2
            field_name = field_tokens[1]
            search_string = field_tokens[2]

            puts "  using BOOL operator  : #{@current_bool_op}"
            puts "  found field name     : #{field_name}"
            puts "  found search string  : #{search_string}"

            trimmed_search_string = search_string.strip
            clean_search_string = sanitize_query(trimmed_search_string)

            puts "  cleaned search string: " + clean_search_string

            # make sure we're only processing advanced search fields we know.
            # query strings will be added to @combined_query_list list object
            if search_string and ADVANCED_SEARCH_FIELDS.include? field_name.to_sym
              case field_name
              when "keyword"
                add_field_adv_search_keyword(KEYWORD_FIELDS, clean_search_string, @current_bool_op)
              when "title"
                add_field_adv_search(['title', 'title.en_folded', 'title.el_folded', 'sort_title', 'sort_title.en_folded', 'sort_title.el_folded'], clean_search_string, @current_bool_op)
              when "journal"
                add_field_adv_search(['journal.title', 'journal.title.en_folded', 'journal.title.el_folded', 'journal.sort_title', 'journal.sort_title.en_folded', 'journal.sort_title.el_folded'], clean_search_string, @current_bool_op)
              when "location"
                add_field_adv_search(['publication_places.place.name', 'publication_places.place.name.en_folded', 'publication_places.place.name.el_folded'], clean_search_string, @current_bool_op)
              when "component_title"
                add_field_adv_search(['components.title', 'components.title.en_folded', 'components.title.el_folded'], clean_search_string, @current_bool_op)
              when "people"
                add_field_adv_search(PEOPLE_FIELDS, clean_search_string, @current_bool_op)
              when "topic_author"
                add_field_adv_search(['topic_author.full_name', 'topic_author.full_name.en_folded', 'topic_author.full_name.el_folded'], clean_search_string, @current_bool_op)
              when "citation_name"
                add_field_adv_search(['text_citations.name', 'text_citations.name.en_folded', 'text_citations.name.el_folded'], clean_search_string, @current_bool_op)
              when "component_citation_name"
                add_field_adv_search(['components.component_citations.name', 'components.component_citations.name.en_folded', 'components.component_citations.name.el_folded'], clean_search_string, @current_bool_op)
              when "volume"
                add_field_adv_search(['volume.title', 'volume.title.en_folded', 'volume.title.el_folded', 'volume.sort_title', 'volume.sort_title.en_folded', 'volume.sort_title.el_folded'], clean_search_string, @current_bool_op)
              when "text_type"
                add_field_adv_search(['text_type.exact'], clean_search_string, @current_bool_op)
              when "material_type"
                add_field_adv_search(['material_type.exact'], clean_search_string, @current_bool_op)
              when "genre"
                add_field_adv_search(['genre.exact'], clean_search_string, @current_bool_op)
              when "original_greek_title"
                add_field_adv_search(['original_greek_title', 'original_greek_title.el_folded'], clean_search_string, @current_bool_op)
              when "original_greek_place_of_publication"
                add_field_adv_search(['original_greek_place_of_publication', 'original_greek_place_of_publication.el_folded'], clean_search_string, @current_bool_op)
              when "original_greek_publisher"
                add_field_adv_search(['original_greek_publisher', 'original_greek_publisher.el_folded'], clean_search_string, @current_bool_op)
              when "original_greek_collection"
                add_field_adv_search(['original_greek_collection', 'original_greek_collection.el_folded'], clean_search_string, @current_bool_op)
              when "publisher"
                add_field_adv_search(['publisher', 'publisher.en_folded', 'publisher.el_folded'], clean_search_string, @current_bool_op)
              when "source"
                add_field_adv_search(['source', 'source.en_folded', 'source.el_folded'], clean_search_string, @current_bool_op)
              when "census_id"
                add_field_adv_search(['census_id.exact'], clean_search_string, @current_bool_op)
              when "series"
                add_field_adv_search(['series', 'series.en_folded', 'series.el_folded'], clean_search_string, @current_bool_op)
              when "sponsoring_organization"
                add_field_adv_search(['sponsoring_organization', 'sponsoring_organization.en_folded', 'sponsoring_organization.el_folded'], clean_search_string, @current_bool_op)
              when "issue_title"
                add_field_adv_search(['issue_title', 'issue_title.el_folded', 'issue_title.en_folded'], clean_search_string, @current_bool_op)
              when "issue_editor"
                add_field_adv_search(['issue_editor', 'issue_editor.el_folded', 'issue_editor.en_folded'], clean_search_string, @current_bool_op)
              when "authors_name_from_source"
                add_field_adv_search(['authors_name_from_source', 'authors_name_from_source.en_folded', 'authors_name_from_source.el_folded'], clean_search_string, @current_bool_op)
              when "standard_numbers"
                add_field_adv_search(['standard_numbers.value.exact'], clean_search_string, @current_bool_op)
              when "collection"
                add_field_adv_search(['collection', 'collection.en_folded', 'collection.el_folded'], clean_search_string, @current_bool_op)
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
          puts "  updating BOOL operator to: #{tok.upcase}"
          @current_bool_op = tok.upcase
        else
          raise ArgumentError.new("The advanced search query has an unknown boolean operator: " + tok)
        end
      end
    end

    # process filters
    if params[:publication_date_range]
      puts "\nreceived publication_date_range value as a filter"
      @filter_hash = add_facet_search_date_range('publication_date_range', :publication_date_range, true)
      if @filter_hash
        @adv_search_array << @filter_hash
      end
    else
      #@filter_hash = {}
    end

    puts "\nUpdated combined_query_list: #{@combined_query_string} \n\n"

    # our @combined_query_string is inserted into an @combined_query_hash "query" key hash
    if @combined_query_string.length > 0
      @combined_query_hash[:query_string][:default_operator] = "and"
      @combined_query_hash[:query_string][:query] = @combined_query_string

      # add @combined_query_hash to our @adv_search_array array of search objects
      @adv_search_array << @combined_query_hash
    end

    @adv_search_array
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

  def add_facet_search_date_range(field, param, as_adv_filter=false)
    add_field_search_date_range(field, param, as_adv_filter, true)
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
  def add_field_adv_search(fields, field_val, bool_op = "AND")
    # loop through fields list and create field_name:search_term pair string, and add them to @combined_fields_list list
    @combined_fields_list = []

    # handle field_vals that are multiple words
    # A search on Title with terms `cavafy cafe` will produce a grouping similar to: (title:cavafy AND title:cafe)
    fields.each do |field_str|
      @combined_field_parts_list = []
      field_val.split(" ").each do |field_val_part|
        @combined_field_parts_list << "#{field_str}:#{field_val_part}"
      end
      @combined_fields_list << "(#{@combined_field_parts_list.join(" AND ")})"
    end

    # each term in @combined_fields_list list will be OR'ed together and grouped by parentheses, and saved as a string
    # @fields_list      = [D, E, F]
    # combo_field_group = (D OR E OR F)
    combo_field_group = "(#{@combined_fields_list.join(" OR ")})"

    # create a combo_query string to include the combo_field_group, the bool operator and fields_list,
    # and then group by parentheses
    #
    # EX:
    #     wrapping parentheses   = (                               )
    #     @combined_query_string = | (A AND B)                     |
    #     bool_op                = |  |         AND                |
    #     combo_field_group      = |  |         |    (D OR E OR F) |
    #                              |  |         |     |            |
    #                              v  v         v     v            v
    #     combo_query            = ( (A AND B)  AND  (D OR E OR F) )
    #
    if bool_op and @combined_query_string.length > 0
      combo_field = "(#{@combined_query_string} #{bool_op} #{combo_field_group})"
    else
      combo_field = combo_field_group
    end

    puts "  current query_string : #{combo_field_group}"
    puts "  updated query_string : #{combo_field}"

    # finally, save as the @combined_query_string
    @combined_query_string = combo_field
  end

  def add_field_adv_search_keyword(keyword_fields, field_val, bool_op = "AND")

    # create a combo_query string to include the combo_field_group, the bool operator and fields_list,
    # and then group by parentheses
    #
    # EX:
    #     wrapping parentheses   = (                               )
    #     @combined_query_string = | (A AND B)                     |
    #     bool_op                = |  |         AND                |
    #     combo_field_group      = |  |         |    (D OR E OR F) |
    #                              |  |         |     |            |
    #                              v  v         v     v            v
    #     combo_query            = ( (A AND B)  AND  (D OR E OR F) )
    #
    if bool_op and @combined_query_string.length > 0
      combo_field = "(#{@combined_query_string} #{bool_op} #{field_val})"
    else
      combo_field = field_val
    end

    puts "  adding keyword search string : #{field_val}"
    puts "  updated query_string : #{combo_field}"

    # add query_string params unique to keyword search
    @combined_query_hash[:query_string][:fields] = keyword_fields
    @combined_query_hash[:query_string][:lenient] = true
    @combined_query_hash[:query_string][:type] = "most_fields"
    @combined_query_hash[:query_string][:default_operator] = "and"

    # finally, save as the @combined_query_string
    @combined_query_string = combo_field
  end

  # Add a date range search
  def add_field_search_date_range(field, param, as_adv_filter, is_facet=false)
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

          range_hash = {
              range: {
                  "sort_date": {
                      gte: @publication_date_range_earliest,
                      lte: @publication_date_range_latest,
                      format: "yyyy"
                  }
              }
          }

          if as_adv_filter
            range_hash
          else
            @query_string_array << range_hash
          end

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
    when 'sort-title'
      [{'sort_title.keyword' => {order: 'asc'}}, '_score']
    else
      ['_score']
    end
  end
end