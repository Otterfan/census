class Public::VolumesController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  # GET /public/volumes
  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)

    @alpha_params_options = {
        bootstrap3: true,
        include_all: false,
        js: false
    }

    # @volumes = Volume.order(:title).page(params[:page])

    # the alpha_paginate gem has a bug where it fail if the field contains an empty or blank value.
    # be sure to filter out empty field values!
    @volumes, @alpha_params = Volume
                                  .where.not(title: [nil, ''])
                                  .order(:title)
                                  .alpha_paginate(@letter, @alpha_params_options){|volume| volume.sort_title.downcase}
  end

  # GET /public/volumes/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to volumes_path(@volumes)
    @volume = Volume.find(params[:id])
    @citations = VolumeCitation.where(:volume_id => @volume.id)
    @referenced_texts = Text.where(:volume_id => @volume.id)
  end
end
