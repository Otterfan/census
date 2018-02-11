class Public::SearchController < ApplicationController
  layout "public"

  # GET /public/search
  # GET /public/search.json ???
  #

  def search
    if params[:keyword].present? ||
        params[:title].present? ||
        params[:journal].present? ||
        params[:location].present? ||
        params[:people].present?

      query_string_array = []

      all_search = {
          query: {
              bool: {}
          }
      }

      if params[:keyword].present?
        query_string_array << {
            query_string: {
                fields: %w{
                  title
                  original
                  original_greek_title
                  date
                  journal.title
                  publisher
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

      # insert filter to all_search hash
      all_search[:query][:bool][:must] = query_string_array

      @texts = Text.search(all_search)
    else
      @new_search = true
      @texts = []
    end
  end

  private
  def search_params
    params.permit(:keyword, :title, :journal, :location, :people, )
  end
end
