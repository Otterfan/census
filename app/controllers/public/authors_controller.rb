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
        include_all: false,
        js: false
    }

    @authors, @alpha_params = Person
                                  .where(topic_flag: true)
                                  .where.not(full_name: [nil, '']) # filter out nils and blanks
                                  .joins(:texts) # only show authors with texts
                                  .group('people.id')
                                  .order(:full_name)
                                  .alpha_paginate(@letter, @alpha_params_options) {|person| person.full_name}
  end

  def show
    @results_formatter = BriefResultFormatter.new([],[],[])
    @author = Person.find(params[:id])
    @texts = @author.texts.order(:sort_census_id).page(params[:page])
  end
end
