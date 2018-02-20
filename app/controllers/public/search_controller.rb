class Public::SearchController < ApplicationController
  layout "public"

  # GET /public/search
  # GET /public/search.json ???
  #

  def search
    # set the number of results per page for this specific search controller.
    # this overrides the paginates_per variable in the Text model
    @pagination_page_size = 10

    if params[:type] == "adv"
      @search_type = "adv"
    else
      @search_type = "kw"
    end

    if params[:keyword].present? ||
        params[:title].present? ||
        params[:journal].present? ||
        params[:location].present? ||
        params[:people].present? ||
        params[:genre].present? ||
        params[:material_type].present? ||
        params[:text_type].present? ||
        params[:topic_author].present? ||
        params[:publication_places].present? ||
        params[:other_text_languages].present?

      query_string_array = []

      @facets = {}

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
                query: params[:keyword],
            }
        }
      end

      if params[:title].present?
        query_string_array << {
            query_string: {
                fields: ['title'],
                query: params[:title]
            }
        }
      end

      if params[:journal].present?
        query_string_array << {
            query_string: {
                fields: ['journal.title'],
                query: params[:journal]
            }
        }
      end

      if params[:location].present?
        query_string_array << {
            query_string: {
                fields: ['publication_places.place.name'],
                query: params[:location]
            }
        }
      end

      if params[:genre].present?
        @facets["genre"] = params[:genre]
        query_string_array << {
            query_string: {
                fields: ['genre'],
                query: params[:genre]
            }
        }
      end

      if params[:material_type].present?
        @facets["material_type"] = params[:material_type]
        query_string_array << {
            query_string: {
                fields: ['material_type'],
                query: params[:material_type]
            }
        }
      end

      if params[:text_type].present?
        @facets["text_type"] = params[:text_type]
        query_string_array << {
            query_string: {
                fields: ['text_type'],
                query: params[:text_type]
            }
        }
      end

      if params[:topic_author].present?
        @facets["topic_author"] = params[:topic_author]
        query_string_array << {
            query_string: {
                fields: ['topic_author.full_name'],
                query: params[:topic_author]
            }
        }
      end

      if params[:publication_places].present?
        @facets["publication_places"] = params[:publication_places]
        query_string_array << {
            query_string: {
                fields: ['publication_places.place.name'],
                query: params[:publication_places]
            }
        }
      end

      if params[:other_text_languages].present?
        @facets["other_text_languages"] = params[:other_text_languages]
        query_string_array << {
            query_string: {
                fields: ['other_text_languages.language.name'],
                query: params[:other_text_languages]
            }
        }
      end

      if params[:people].present?
        query_string_array << {
            query_string: {
                fields: %w{
                  text_citations.name
                  components.component_citations.name
                  topic_author.full_name
                },
                query: params[:people]
            }
        }
      end

      # create elasticsearch search query
      all_search = {
          query: {
              bool: {
                  must: query_string_array
              }
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

      @texts = Text.search(all_search).page(params[:page]).per(@pagination_page_size)


      # create facet delete urls
      @facet_delete_paths = {}
      @facets.each do |k, v|
        new_hash = {}
        new_hash[:utf8] = "✓"
        new_hash[:type] = @search_type
        new_hash[:keyword] = params[:keyword]
        new_hash.merge!(@facets.deep_dup)

        new_hash.each do |f, w|
          if k == f
            new_hash.delete(k)
          end
        end

        @facet_delete_paths[k] = new_hash
      end
    else
      @new_search = true
      @texts = []
    end
  end

  private
  def search_params
    params.permit(:keyword, :title, :journal, :location, :people, :type,
                  :genre, :material_type, :text_type, :topic_author, :publication_places, :other_text_languages)
  end
end
