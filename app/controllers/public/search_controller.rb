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


      if params[:keyword].present?
        all_search = {
           query: {
               bool: {
                   must: {
                       multi_match: {
                           query: params[:keyword],
                           type: "best_fields",
                           fields: %w{
                              title
                              original
                              journal.title
                              publisher
                              publication_places.place.name
                              topic_author.full_name
                              topic_author.alternate_name
                              text_citations.name
                              components.title
                              components.component_citations.name
                           }
                       }
                   }
               }
           }
        }
      else
        all_search = {
            query: {
                bool: {
                    must: {
                        match_all: {}
                    }
                }
            }
        }
      end

      # TODO check filter logic
      if params[:title].present? ||
          params[:journal].present? ||
          params[:location].present? ||
          params[:people].present?

        filter_array = []

        if params[:title].present?
          filter_array << {term: {title: params[:title]}}
        end

        if params[:journal].present?
          filter_array << {term: {'journal.title' => params[:journal]}}
        end

        if params[:location].present?
          filter_array << {term: {'publication_places.place.name'=> params[:location]}}
        end

        # TODO add in nested OR filter for both text_citations.name and components.component_citations.name
        if params[:people].present?
          filter_array << {term: {'text_citations.name': params[:people]}}
        end


        # insert filter to all_search hash
        all_search[:query][:bool][:filter] = filter_array

      end

      @texts = Text.search(all_search)
    else
      @new_search = true
      @texts = []
    end
  end

  def index_old
    # TODO check if using PostgreSQL or other RDB since the 'ILIKE' operator isn't universal

    if params[:keyword].present? ||
        params[:title].present? ||
        params[:journal].present? ||
        params[:location].present? ||
        params[:people].present?

      @new_search = false

      if params[:keyword].present?
        # this is calling the pg_search.search() module method for full-text search
        @texts = Text.search(params[:keyword])
      else
        @texts = Text.order(:title)
      end

      if params[:title].present?
        @texts = @texts.where('title ILIKE ?', "%#{params[:title]}%")
      end

      if params[:journal].present?
        @texts = @texts.where('journal_title ILIKE ?', "%#{params[:journal]}%")
      end

      if params[:location].present?
        @texts = @texts.where('place_of_publication ILIKE ?', "%#{params[:location]}%")
      end

      # :people is searched across two separate tables:
      #   * text_citations.name
      #   * component_citations.name
      #
      # we run a complex JOIN with explicit aliasing to avoid issues with full-text search automatic aliases
      if params[:people].present?
        # TODO consider using AREL to simplify complex SQL queries
        # https://github.com/rails/arel
        @texts = @texts.joins("LEFT OUTER JOIN text_citations tc ON tc.text_id = texts.id")
                     .joins("LEFT OUTER JOIN components c ON c.text_id = texts.id")
                     .joins("LEFT OUTER JOIN component_citations cc ON cc.component_id = c.id")
                     .where('tc.name ILIKE ? OR cc.name ILIKE ?', "%#{params[:people]}%", "%#{params[:people]}%")

        # joins() method doesn't support aliasing, which is necessary to not conflict with complex full-text JOINs
        # @texts = @texts.joins(:text_citations).where('text_citations.name ILIKE ?', "%#{params[:people]}%")

        # includes() method isn't the preferred way to JOIN tables
        # @texts = @texts.includes(:text_citations).where(text_citations: {name: "%#{params[:people]}%"})
      end
    else
      # if none of the search params are present then consider this a new search view
      @new_search = true
    end
  end

  private
  def search_params
    params.permit(:keyword, :title, :journal, :location, :people, )
  end
end
