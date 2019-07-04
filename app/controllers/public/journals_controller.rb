class Public::JournalsController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  # GET /public/journals
  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)

    @alpha_params_options = {
        bootstrap3: true,
        include_all: false,
        js: false
    }

    # @journals = Journal.order(:title).page(params[:page])

    # the alpha_paginate gem has a bug where it fail if the field contains an empty or blank value.
    # be sure to filter out empty field values!
    @journals, @alpha_params = Journal
                                   .where.not(title: [nil, ''])
                                   .order(:title)
                                   .alpha_paginate(@letter, @alpha_params_options){|journal| journal.sort_title.downcase}
  end

  # GET /public/journals/1
  # TODO don't use multiple controller actions across different Models
  def show
    #redirect_to journals_path(@journals)
    @journal = Journal.find(params[:id])
    @referenced_texts = Text.where(:journal_id => @journal.id).order(census_id: :desc)
  end
end
