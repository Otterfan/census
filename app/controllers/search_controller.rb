class SearchController < ApplicationController
  layout "public"
  include TextsHelper

  KEYWORD_SEARCH_PARAMS = [
      :keyword,
      :genre,
      :material_type,
      :text_type,
      :topic_author,
      :publication_places,
      :publication_date_range
  ]

  ADVANCED_SEARCH_PARAMS = [
      :keyword,
      :bq,
      :title,
      :author_heading,
      :persons_cited,
      :entry_number,
      :text_type,
      :material_type,
      :genre,
      :journal_title,
      :volume_title,
      :collection_title,
      :original_greek_title,
      :publication_place,
      :publication_countries,
      :publisher,
      :series,
      :sponsoring_organization,
      :isbn,
      :issn,
      :dai,
      :is_bilingual,
      :illustrations_noted,
      :is_special_issue,
      :is_collected_volume,
      :authors_name_from_source,
      :authors_name_from_source_exact
  ]

  SEARCH_PARAMS = KEYWORD_SEARCH_PARAMS + ADVANCED_SEARCH_PARAMS

  DEFAULT_VIEW_PARAMS = [
      :title,
      :topic_author
  ]

  UNIFIED_TITLE_FIELDS = %w{
      title.en
      title.el
      title.en_folded
      title.el_folded
      sort_title
      sort_title.en_folded
      sort_title.el_folded
      components.title
      components.title.en
      components.title.el
      components.title.en_folded
      components.title.el_folded
      components.sort_title
      components.sort_title.en_folded
      components.sort_title.el_folded
      components.greek_collection_title_clean
      components.greek_collection_title_clean.el
      components.greek_collection_title_clean.el_folded
      components.greek_source_title_clean
      components.greek_source_title_clean.el
      components.greek_source_title_clean.el_folded
      journal.title
      journal.title.en
      journal.title.el
      journal.title.en_folded
      journal.title.el_folded
      journal.sort_title
      journal.sort_title.en_folded
      journal.sort_title.el_folded
      volume.title
      volume.title.en_folded
      volume.title.el_folded
      volume.sort_title
      volume.sort_title.en_folded
      volume.sort_title.el_folded
      original_greek_title_clean
      original_greek_title_clean.el_folded
      original_greek_collection_clean
      original_greek_collection_clean.el_folded
      issue_title
      issue_title.el_folded
      issue_title.en_folded
      collection_clean
      collection_clean.en_folded
      collection_clean.el_folded
      components.collection_clean
      components.collection_clean.en_folded
      components.collection_clean.el_folded
  }

  UNIFIED_PERSONS_CITED_FIELDS = %w{
      topic_author.full_name
      topic_author.full_name.en_folded
      topic_author.full_name.el_folded
      topic_author.alternate_name
      topic_author.alternate_name.en_folded
      topic_author.alternate_name.el_folded
      topic_author.alternate_name_clean
      topic_author.alternate_name_clean.en_folded
      topic_author.alternate_name_clean.el_folded
      authors_name_from_source
      authors_name_from_source.el_folded
      authors_name_from_source.en_folded
      text_citations.name
      text_citations.name.en_folded
      text_citations.name.el_folded
      text_citations.name.controlled_name
      text_citations.name.controlled_name.en_folded
      text_citations.name.controlled_name.el_folded
      components.component_citations.name
      components.component_citations.name.en_folded
      components.component_citations.name.el_folded
      components.component_citations.controlled_name
      components.component_citations.controlled_name.en_folded
      components.component_citations.controlled_name.el_folded
      volume.volume_citations.name
      volume.volume_citations.name.en_folded
      volume.volume_citations.name.el_folded
      volume.volume_citations.controlled_name
      volume.volume_citations.controlled_name.en_folded
      volume.volume_citations.controlled_name.el_folded
      issue_editor
      issue_editor.en_folded
      issue_editor.el_folded
  }

  TOPIC_AUTHOR_FIELDS = %w{
      topic_author.full_name
      topic_author.full_name.en_folded
      topic_author.full_name.el_folded
      topic_author.greek_full_name
      topic_author.greek_full_name.en_folded,
      topic_author.greek_full_name.el_folded
  }

  PUBLICATION_PLACES = %w{
      publication_places.place.name
      publication_places.place.name.en_folded
      publication_places.place.name.el_folded
      publication_places.place.subdivision
      publication_places.place.subdivision.en_folded
      publication_places.place.subdivision.el_folded
      publication_places.place.country.name
      publication_places.place.country.name.en_folded
      publication_places.place.country.name.el_folded
      publication_places.place.country.al3_code.exact
  }

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

  BOOL_AND = "AND"
  BOOL_OR = "OR"
  BOOL_NOT = "NOT"

  KEYWORD_FIELDS = %w{
    census_id
    text_type.exact^5
    component.text_type.exact^5
    material_type.exact

    topic_author.full_name^10
    topic_author.full_name.en_folded^10
    topic_author.full_name.el_folded^10
    topic_author.alternate_name^10
    topic_author.alternate_name.en_folded^10
    topic_author.alternate_name.el_folded^10
    topic_author.alternate_name_clean^10
    topic_author.alternate_name_clean.en_folded^10
    topic_author.alternate_name_clean.el_folded^10

    topic_author.greek_full_name.el_folded^10
    topic_author.greek_full_name.el^10

    authors_name_from_source
    authors_name_from_source.exact
    authors_name_from_source.el_folded
    authors_name_from_source.en_folded

    issue_editor
    issue_editor.en_folded
    issue_editor.el_folded

    volume.volume_citations.name
    volume.volume_citations.name.en_folded
    volume.volume_citations.name.el_folded
    volume.volume_citations.controlled_name
    volume.volume_citations.controlled_name.en_folded
    volume.volume_citations.controlled_name.el_folded

    title^10
    title.en^10
    title.el^10
    title.en_folded^10
    title.el_folded^10
    sort_title^10
    sort_title.en_folded^10
    sort_title.el_folded^10
    greek_source_title^10
    greek_source_title.el^10
    greek_source_title.el_folded^10

    text_citations.name^10
    text_citations.name.en^10
    text_citations.name.el^10
    text_citations.name.en_folded^10
    text_citations.name.el_folded^10
    text_citations.controlled_name^10
    text_citations.controlled_name.en^10
    text_citations.controlled_name.el^10
    text_citations.controlled_name.en_folded^10
    text_citations.controlled_name.el_folded^10
    text_citations.role.exact^5
    volume.title
    volume.title.en
    volume.title.el
    volume.title.en_folded
    volume.title.el_folded
    volume.sort_title
    volume.sort_title.en_folded
    volume.sort_title.el_folded
    series
    series.en
    series.el
    series.en_folded
    series.el_folded

    publication_places.place.name
    publication_places.place.name.en
    publication_places.place.name.el
    publication_places.place.name.en_folded
    publication_places.place.name.el_folded
    publication_places.place.subdivision
    publication_places.place.subdivision.en_folded
    publication_places.place.subdivision.el_folded
    publication_places.place.country.name
    publication_places.place.country.name.en_folded
    publication_places.place.country.name.el_folded
    publication_places.place.country.al3_code.exact
    publisher
    publisher.en_folded
    publisher.el_folded

    sort_date

    components.title
    components.title.en
    components.title.el
    components.title.en_folded
    components.title.el_folded
    components.sort_title^5
    components.sort_title.en_folded^5
    components.sort_title.el_folded^5
    components.genre
    components.text_type
    components.collection_clean
    components.collection_clean.en_folded
    components.collection_clean.el_folded
    components.note
    components.note.en_folded
    components.note.el_folded
    components.greek_source_title^5
    components.greek_source_title.el^5
    components.greek_source_title.el_folded^5
    components.greek_collection_title^5
    components.greek_collection_title.el^5
    components.greek_collection_title.el_folded^5

    genre.exact^5
    component.genre.exact^5

    url

    journal.title^5
    journal.title.en_folded^5
    journal.title.el_folded^5
    journal.sort_title^5
    journal.sort_title.en_folded^5
    journal.sort_title.el_folded^5
    searchable_is_special_issue^5000
    searchable_is_collected_volume^5000

    sponsoring_organization
    sponsoring_organization.en_folded
    sponsoring_organization.el_folded

    collection_clean
    collection_clean.en_folded
    collection_clean.el_folded

    standard_numbers.value
    journal.issn
    dai

    components.component_citations.name^10
    components.component_citations.name.en_folded^10
    components.component_citations.name.el_folded^10
    components.component_citations.role.exact^5
    components.component_citations.genre.exact^5
    components.component_citations.text_type.exact
    components.component_citations.collection^10
    components.component_citations.collection.en_folded^10
    components.component_citations.collection.el_folded^10
    components.component_citations.controlled_name^10
    components.component_citations.controlled_name.en_folded^10
    components.component_citations.controlled_name.el_folded^10

    note_clean
    note_clean.en_folded
    note_clean.el_folded
    abstract_clean
    abstract_clean.en_folded
    abstract_clean.el_folded
    editorial_annotation_clean
    editorial_annotation_clean.en_folded
    editorial_annotation_clean.el_folded
    physical_description_clean
    physical_description_clean.en_folded
    physical_description_clean.el_folded

    source
    source.en_folded
    source.el_folded
    original_greek_title^10
    original_greek_title.el^10
    original_greek_title.el_folded^10
    original_greek_collection
    original_greek_collection.el
    original_greek_collection.el_folded
    original_greek_place_of_publication
    original_greek_place_of_publication.el
    original_greek_place_of_publication.el_folded
    original_greek_publisher
    original_greek_publisher.el
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
    original_clean.en
    original_clean.el
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
      escaped_word = word.split('').map { |char| "\\#{char}" }.join('')
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
        mapped_uniq_vals = uniq_vals.map { |v| [format_label(v), v] }
        @unique_values[field_s] = mapped_uniq_vals
      elsif field_s == "genre"
        # genre is a combination of top-level Text and components
        all_fields = []
        unique_component_vals = Component.get_unique_values(field_s)
        unique_component_vals.each do |genre_entry|
          genres = genre_entry.split(' | ')
          all_fields = all_fields + genres
        end

        # merge the two genre lists and find all unique values between the two
        uniq_vals.each do |genre_entry|
          genres = genre_entry.split(' | ')
          all_fields = all_fields + genres
        end
        @unique_values[field_s] = all_fields.uniq.sort
      else
        @unique_values[field_s] = uniq_vals
      end
    end

    if is_search?
      @query_hash = {}
      @query_string_array = []
      @facets = {}

      RecentSearch::add(session.id&.public_id, search_params)

      if @search_type == "adv"
        # process_adv_search method can raise ArgumentError.
        begin
          @query_string_array = process_adv_search

          parsed_query = AdvancedSearchQuery.new(params[:bq])
          @selected_text_types = parsed_query.text_type
          @selected_material_types = parsed_query.material_type
          @selected_genres = parsed_query.genre

          # facet filter fields
          # the add_facet_search method will add in a query_string hash to the @query_string_array array
          add_facet_search(['available_online'], :available_online)
          add_facet_search(['genre'], :genre)
          add_facet_search(['material_type'], :material_type)
          add_facet_search(['text_type'], :text_type)
          add_facet_search(['topic_author.full_name'], :topic_author)
          add_facet_search(['publication_places.place.name'], :publication_places)
          add_facet_search(['other_text_languages.language.name'], :other_text_languages)
          add_facet_search(['components.collection'], :original_source)
          add_facet_search_date_range('publication_date_range', :publication_date_range)
          add_facet_search(['translators_names'], :translators)

          @query_array = @query_string_array

        rescue ArgumentError => e
          puts "\nCaught error: #{e.message}"
          puts "Setting @new_search = true\n\n"
          @new_search = true
          @texts = []
          return
        end
      else
        # add the keyword hash to @query_string_array
        @query_string_array << generate_keyword_search_array(params[:keyword])

        puts "query_string array "
        puts @query_string_array

        # facet filter fields
        # the add_facet_search method will add in a query_string hash to the @query_string_array array
        add_facet_search(['available_online'], :available_online)
        add_facet_search(['genre'], :genre)
        add_facet_search(['material_type'], :material_type)
        add_facet_search(['text_type'], :text_type)
        add_facet_search(['topic_author.full_name'], :topic_author)
        add_facet_search(['publication_places.place.name'], :publication_places)
        add_facet_search(['other_text_languages.language.name'], :other_text_languages)
        add_facet_search_date_range('publication_date_range', :publication_date_range)
        add_facet_search(['translators_names'], :translators)

        @query_array = @query_string_array
      end

      # create Elasticsearch search query using the @query_array list we've been constructing.
      # add in aggregated fields (facets), highlighting and sort configuration here
      @all_search = {
          query: {},
          sort: query_sort(params[:sort]),
          aggs: {
              available_online: {
                  terms: {
                      field: "available_online.keyword",
                      size: FACET_HITS_SIZE
                  }
              },
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
              "translators": {
                  terms: {
                      field: "translators_names.keyword",
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
      if @query_array.any?
        @all_search[:query][:bool] = {}
        @all_search[:query][:bool][:must] = @query_array
      else
        @all_search[:query] = {
            "match_all": {}
        }
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
        ['Title', 'sort-title'],
        ['Author', 'author'],
        ['Date (oldest first)', 'date-oldest-first'],
        ['Date (newest first)', 'date-newest-first']
    ]
    @page_title = page_title
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

    # we allow empty adv search queries
    if !params[:bq].present?
      params[:bq] = ""
    end

    # example of raw combined bool search query string
    # bq=(title::complete poems)--OR--(author_heading::cavafy)--AND--(genre::poetry::essay)

    # simple sanity checking
    # check that the first and last characters in the search string are parentheses
    if params[:bq].present? and (params[:bq][0] != "(" or params[:bq][-1] != ")")
      raise ArgumentError.new("The advanced search query is malformed.")
    end

    # First, split query string by double dashes to get tokens like:
    # [0] (title::complete poems)
    # [1] OR
    # [2] (author_heading::cavafy)
    # [3] AND
    # [4] (genre::poetry::essay)
    #
    # NB There is a pattern where boolean operators are on odd-numbered indices
    #    and the fields & values are on even-numbered indices. There will always
    #    be an odd number of indices with this pattern.

    tokens = params[:bq].split("--")

    puts "\nList of tokens in ADVANCED search:"
    tokens.each_with_index do |t, i|
      puts "  [#{i}] #{t}"
    end

    # simple sanity checking
    # we always expect an odd number or zero number of tokens
    if tokens.length != 0 and tokens.length.even?
      raise ArgumentError.new("The advanced search query has an unexpected number of tokens: " + tokens.length.to_s)
    end

    # regular expression used to match the field name and search string from the combined bool search query
    match_re = /^\((\w+)::(.+)\)$/i

    # Next, process each type of token by even- and odd-numbered indexes
    tokens.each_with_index do |tok, i|
      puts "\nLooking at token [#{i}]: #{tok}"
      if i.modulo(2).even?
        # get even numbered tokens
        #
        # (field_name::search_string)

        field_tokens = match_re.match(tok)

        # we know that we should only match two or more elements with our regex: a field name and search string(s)
        if field_tokens
          if field_tokens.length >= 2
            field_name = field_tokens[1]
            search_string = field_tokens[2]

            puts "  using BOOL operator  : #{@current_bool_op}"
            puts "  found field name     : #{field_name}"
            puts "  found search string  : #{search_string}"

            trimmed_search_string = search_string.strip
            clean_search_string = sanitize_query(trimmed_search_string)

            # puts "  cleaned search string: " + clean_search_string

            # make sure we're only processing advanced search fields we know.
            # query strings will be added to @combined_query_list list object
            if search_string and ADVANCED_SEARCH_PARAMS.include? field_name.to_sym
              case field_name
              when "keyword"
                add_field_adv_search_keyword(KEYWORD_FIELDS, clean_search_string, @current_bool_op)
              when "title"
                add_field_adv_search(UNIFIED_TITLE_FIELDS, clean_search_string, @current_bool_op)
              when "author_heading"
                add_field_adv_search(TOPIC_AUTHOR_FIELDS, clean_search_string, @current_bool_op)
              when "persons_cited"
                add_field_adv_search(UNIFIED_PERSONS_CITED_FIELDS, clean_search_string, @current_bool_op)
              when "entry_number"
                add_field_adv_search(['census_id'], clean_search_string, @current_bool_op)
              when "text_type"
                # process this field type as a advanced search filter
                add_field_adv_search_filter(['text_type.exact', 'component.text_type.exact'], trimmed_search_string, @current_bool_op)
              when "material_type"
                # process this field type as a advanced search filter
                add_field_adv_search_filter(['material_type.exact'], trimmed_search_string, @current_bool_op)
              when "genre"
                # process this field type as a advanced search filter
                add_field_adv_search_filter(['genre.exact', 'components.genre.exact'], trimmed_search_string, @current_bool_op)
              when "journal_title"
                add_field_adv_search(['journal.title', 'journal.title.en_folded', 'journal.title.el_folded', 'journal.sort_title', 'journal.sort_title.en_folded', 'journal.sort_title.el_folded'], clean_search_string, @current_bool_op)
              when "volume_title"
                add_field_adv_search(['volume.title', 'volume.title.en_folded', 'volume.title.el_folded'], clean_search_string, @current_bool_op)
              when "collection_title"
                add_field_adv_search(['original_greek_collection', 'original_source'], clean_search_string, @current_bool_op)
              when "original_greek_title"
                add_field_adv_search(['original_greek_title', 'original_greek_title.el_folded'], clean_search_string, @current_bool_op)
              when "publication_place"
                add_field_adv_search(PUBLICATION_PLACES, clean_search_string, @current_bool_op)
              when "publication_countries"
                add_field_adv_search(['publication_countries'], clean_search_string, @current_bool_op)
              when "publisher"
                add_field_adv_search(['publisher', 'publisher.en_folded', 'publisher.el_folded'], clean_search_string, @current_bool_op)
              when "series"
                add_field_adv_search(['series', 'series.en_folded', 'series.el_folded'], clean_search_string, @current_bool_op)
              when "sponsoring_organization"
                add_field_adv_search(['sponsoring_organization', 'sponsoring_organization.en_folded', 'sponsoring_organization.el_folded'], clean_search_string, @current_bool_op)
              when "issn"
                add_field_adv_search(['journal.issn'], clean_search_string, @current_bool_op)
              when "isbn"
                add_field_adv_search(['standard_numbers.value'], clean_search_string, @current_bool_op)
              when "dai"
                add_field_adv_search(['dai'], clean_search_string, @current_bool_op)
              when "is_bilingual"
                add_field_adv_search(['is_bilingual', 'components.is_bilingual'], clean_search_string, @current_bool_op)
                @is_bilingual = true
              when "is_special_issue"
                add_field_adv_search(['is_special_issue'], clean_search_string, @current_bool_op)
                @is_special_issue = true
              when "is_collected_volume"
                add_field_adv_search(['is_collected_volume'], clean_search_string, @current_bool_op)
                @is_collected_volume = true
              when "illustrations_noted"
                add_field_adv_search(['illustrations_noted'], clean_search_string, @current_bool_op)
                @illustrations_noted = true
              when "authors_name_from_source"
                add_field_adv_search(['authors_name_from_source'], clean_search_string, @current_bool_op)
              when "authors_name_from_source_exact"
                add_field_adv_search(['authors_name_from_source.exact'], clean_search_string, @current_bool_op)
              end
            end
          else
            # in this case we only have a field name but no corresponding search string.
            # this ignores the case where we have at least one valid field name and search string pair.
            raise ArgumentError.new("The advanced search query is missing the search string.")
          end
        else
          puts "  couldn't match on the field regex!"
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

    puts @adv_search_array

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
    params.permit(SEARCH_PARAMS)
  end

  # Return a list of all symbols of search parameters used in the current request
  def used_params
    SEARCH_PARAMS.reject { |key| !params[key].present? }
  end

  # Return true if this is a search request
  def is_search?
    puts "Received the following search params: #{used_params}"

    # allow search if there are valid search params
    # or if the "keyword" param exists but is an empty string
    used_params.length > 0 || params["keyword"] == ""
  end

  # Build ES highlight fields for search fields not used in the view
  def highlight_fields
    fields_to_highlight = SEARCH_PARAMS - used_params
    fields_obj = {}
    fields_to_highlight.each { |field| fields_obj[field] = {} }
    fields_obj
  end

  # Add a search on a facet to the query string array
  def add_facet_search(fields, param)
    add_field_search(fields, param, true)
  end

  def add_facet_search_date_range(field, param, as_adv_filter = false)
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
    # loop through fields array and create field_name:search_term pair string, and add them to @combined_fields_list array
    @combined_fields_list = []

    # Handle field_vals that are multiple words
    # A search on Title with terms `cavafy cafe` will produce a grouping similar to: (title:cavafy AND title:cafe)
    fields.each do |field_str|
      @combined_field_parts_list = []

      # Check if field_val is wrapped in quotes:
      # if true, treat the entire field_val as a single item
      # else, split field_val by whitespace and treat each item as a separate search term
      if /^\".*\"$/.match?(field_val)
        puts "  this search string is wrapped in quotes"
        @combined_field_parts_list << "#{field_str}:#{field_val}"
      else
        field_val.split(" ").each do |field_val_part|
          @combined_field_parts_list << "#{field_str}:#{field_val_part}"
        end
      end
      @combined_fields_list << create_combined_field_group(@combined_field_parts_list, bool_op)
    end

    # Each term in @combined_fields_list array will be OR'ed together and grouped by parentheses, and saved as a string
    #   @fields_list      = [D, E, F]
    #   combo_field_group = (D OR E OR F)
    combo_field_group = create_combined_field_group(@combined_fields_list, BOOL_OR)

    # Finally, return the @combined_query_string using combo_field_group and bool_op
    @combined_query_string = update_combined_query_string(@combined_query_string, combo_field_group, bool_op)
  end

  # Add a specialized advanced search filter query string
  def add_field_adv_search_filter(fields, field_val, bool_op = "AND")
    # We can expect method parameters like:
    #  fields    = ["genre", "components.genre"]
    #  field_val = "poetry::essay"

    # Loop through each element in fields array and handle multiple field_vals terms
    @combined_fields_list = []
    fields.each do |field_str|
      @combined_field_parts_list = []
      @split_tokens_list = []

      # Tokenize field_val into separate values
      #   "poetry::essay".split("::")
      # returns
      #   ["poetry", "essay"]
      vals = field_val.split("::")

      vals.each do |val|
        # Be sure to add double quotes around the val for this filter query
        @split_tokens_list << "#{field_str}:\"#{val}\""
      end

      # The first loop will have a have a @split_tokens_list array that looks like:
      #   ["genre:poetry", "genre:essay"]

      # Join all the @split_tokens_list strings with "OR" and then add the result into @combined_fields_list array
      @combined_fields_list << create_combined_field_group(@split_tokens_list, BOOL_OR)

      # The first loop will have a have a @combined_fields_list array that looks like:
      #   ["genre:poetry OR genre:essay"]
    end

    # By now, we should have a @combined_fields_list array that looks like:
    #   ["genre:poetry OR genre:essay", "components.genre:poetry OR components.genre:essay"]

    # Next, each term in @combined_fields_list array will be OR'ed together and grouped by parentheses, and saved as a string
    #   @combined_fields_list = [D:X, E:Y, F:Z]
    #   combo_field_group     = ((D:X) OR (E:Y) OR (F:Z))
    combo_field_group = create_combined_field_group(@combined_fields_list, BOOL_OR)

    # Finally, return the @combined_query_string using combo_field_group and bool_op
    @combined_query_string = update_combined_query_string(@combined_query_string, combo_field_group, bool_op)
  end

  # Add an advanced search keyword/all fields search query
  def add_field_adv_search_keyword(keyword_fields, field_val, bool_op = "AND")
    # add query_string params unique to keyword search
    @combined_query_hash[:query_string][:fields] = keyword_fields
    @combined_query_hash[:query_string][:lenient] = true
    @combined_query_hash[:query_string][:type] = "most_fields"
    @combined_query_hash[:query_string][:default_operator] = "and"

    # Finally, return the @combined_query_string using field_val and bool_op
    @combined_query_string = update_combined_query_string(@combined_query_string, field_val, bool_op)
  end

  # Create a new query string by joining terms in field_group array with bool_op
  def create_combined_field_group(field_group, bool_op)
    # check how many elements are in the field_group array
    if field_group.length > 1
      # wrap the array elements in parenthesis and join each array element with the bool_op
      "(#{field_group.join(" #{bool_op} ")})"
    else
      # if there is only one term in the array then return it as a string without parenthesis
      field_group.join("")
    end
  end

  # Combine all the query groups into a central query string
  def update_combined_query_string(combined_query, field_group, bool_op = "AND")
    puts "combined_query: #{combined_query}, field_group: #{field_group}, bool_op: #{bool_op}"
    # create a combo_query string to include the field_group, the bool operator and combined_query,
    # and then group by parentheses
    #
    # EX:
    #     wrapping parentheses  = (                               )
    #     combined_query        = | (A AND B)                     |
    #     bool_op               = |  |         AND                |
    #     field_group           = |  |         |    (D OR E OR F) |
    #                             |  |         |     |            |
    #                             v  v         v     v            v
    #     combo_query           = ( (A AND B)  AND  (D OR E OR F) )
    #
    if bool_op and combined_query.length > 0
      combo_query = "(#{combined_query} #{bool_op} #{field_group})"
    else
      combo_query = field_group
    end

    puts "  adding keyword search string: #{field_group}"
    puts "  updated query_string: #{combo_query}"

    combo_query
  end

  # Add a date range search
  def add_field_search_date_range(field, param, as_adv_filter, is_facet = false)
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
    when 'author'
      [{'authors_names.keyword' => {order: 'asc'}}, '_score']
    else
      ['_score']
    end
  end

  def page_title
    if params[:type] == "adv"
      'Advanced search'
    elsif !is_search?
      'New search'
    else
      "#{params[:keyword]} - search"
    end
  end

  def extract_values(field)
    # we allow empty adv search queries
    if !params[:bq].present?
      params[:bq] = ""
    end


  end
end