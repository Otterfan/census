class Public::VolumesController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  # GET /public/journals
  def index
    redirect_to('/public/volumes/letter/A')
  end

  # GET /public/volumes/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@volume)
    @volume = Volume.find(params[:id])
    @referenced_texts = Text.where(:volume_id => @volume.id).order(sort_page_span: :asc)

    # First letter of author's last name
    @first_letter = @volume.sort_title[0, 1]

    @navigation_list = NavigationList.new(Volume, :title, @first_letter)

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

    redirect_to(public_volume_path(first_volume))
  end

end
