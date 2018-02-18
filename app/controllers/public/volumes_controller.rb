class Public::VolumesController < ApplicationController
  layout "public"

  # GET /public/volumes
  # GET /public/volumes.json
  #

  def index
    @volumes = Volume.order(:title).page(params[:page])
  end

  # GET /public/volumes/1
  # GET /public/volumes/1.json
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to volumes_path(@volumes)
    @volume = Volume.find(params[:id])
    @citations = VolumeCitation.where(:volume_id => @volume.id)
    @referenced_texts = Text.where(:volume_id => @volume.id)
  end
end
