require "alphabetical_paginate"

class Public::AuthorsController < ApplicationController
  layout "public"

  before_action :authenticate_user!

  def index
    if params[:letter].present?
      if params[:letter].downcase == "all"
        @letter = "All"
      else
        # sanitize by grabbing first letter only
        # and substitute non-accepted letters with 'A'
        # https://stackoverflow.com/a/17086441
        @sanitized = params[:letter][0,1].gsub(/[^A-Za-zΑ-Ωα-ωίϊΐόάέύϋΰήώ]/, 'A')
        @letter = @sanitized.upcase
      end
    else
      # set default letter to 'A'
      # TODO: we're assuming there will always be a name that begins with 'A'
      @letter = "A"
    end

    # @authors = Person.where(topic_flag: true).order(:full_name).page(params[:page])

    # the alpha_paginate gem has a bug where it fail if the field contains an empty or blank value.
    # be sure to filter out empty field values!
    @authors, @alpha_params = Person
                                  .where(topic_flag: true)
                                  .where.not(full_name: [nil, ''])
                                  .order(:full_name)
                                  .alpha_paginate(@letter, {bootstrap3: true, include_all: false}){|person| person.full_name}
  end

  def show
    @author = Person.find(params[:id])
  end
end
