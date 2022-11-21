class VolumesController < ApplicationController
  include ControllersHelper

  layout "public"

  # GET /public/journals
  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)
    @is_greek_letter = ('Α'..'Ω').include?(@letter)

    @alpha_params_options = {
      bootstrap3: true,
      include_all: false,
      js: false
    }

    @navigation_list = NavigationList.new(Volume, :sort_title, 'A')

    order_field = @is_greek_letter ? 'volumes.sort_title COLLATE "el-GR-x-icu"' : :sort_title

    @volumes = Volume.where("volumes.sort_title LIKE :prefix", prefix: "#{@letter}%")
                     .unscope(:order)
                     .order(order_field)

    @volumes = @volumes.select { |vol| vol.has_visible_text }
  end

  # GET /public/volumes/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@volume)
    @volume = Volume.find(params[:id])
    @referenced_texts = Text.where(:volume_id => @volume.id).where(:is_hidden => false).order(sort_page_span: :asc)

    @editors = @volume.volume_citations.select { |citation| citation.role == 'editor' }
    @translators = @volume.volume_citations.select { |citation| citation.role == 'translator' }

    @other_contributors = @volume.volume_citations.select { |citation| citation.role != 'editor' && citation.role != 'translator' }

  end

  # Go to the first author whose last name starts with
  # first_letter
  def letter
    first_volume = Volume.where.not(title: [nil, '']) # filter out nils and blanks
                         .where("sort_title LIKE ?", "#{params[:first_letter]}%")
                         .order(:sort_title)
                         .first

    redirect_to(volume_path(first_volume))
  end

end
