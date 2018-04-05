require "alphabetical_paginate"

class Public::AuthorsController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)

    # @authors = Person.where(topic_flag: true).order(:full_name).page(params[:page])

    @alpha_params_options = {
        bootstrap3: true,
        include_all: false
    }

    # the alpha_paginate gem has a bug where it fail if the field contains an empty or blank value.
    # be sure to filter out empty field values!
    @authors, @alpha_params = Person
                                  .where(topic_flag: true)
                                  .where.not(full_name: [nil, ''])
                                  .order(:full_name)
                                  .alpha_paginate(@letter, @alpha_params_options){|person| person.full_name}
  end

  def show
    @author = Person.find(params[:id])
  end
end
