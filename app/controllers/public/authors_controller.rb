require "alphabetical_paginate"

class Public::AuthorsController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  def index
    redirect_to('/public/authors/letter/A')
  end

  def show
    @results_formatter = BriefResultFormatter.new([], [], [])
    @author = Person.find(params[:id])

    # All translations by author
    @translations = @author.texts
                 .where("text_type LIKE ?", "translation%")
                 .order(:sort_census_id)
                 .page(params[:translations_page])

    # All studies about author
    @studies = @author.texts
                        .where("text_type LIKE ?", "study%")
                        .order(:sort_census_id)
                        .page(params[:studies_page])

    # All texts
    @texts = @author.texts
                   .order(:sort_census_id)
                   .page(params[:texts_page])

    # First letter of author's last name
    @first_letter = @author.full_name[0, 1]

    # List of authors with same first letter of last name
    @nav_authors = Person.where(topic_flag: true)
                       .where.not(full_name: [nil, '']) # filter out nils and blanks
                       .where("full_name LIKE ?", "#{@first_letter}%")
                       .order(:full_name)

    # List of first letters of authors last names
    @nav_letters = build_navigation_letter_list

  end


  # Builds a list of letters usable in navigation
  #
  # @return [Array]
  def build_navigation_letter_list

    # Get a list of all topic authors
    authors = Person
                  .where(topic_flag: true)
                  .where.not(full_name: [nil, '']) # filter out nils and blanks
                  .joins(:texts) # only show authors with texts
                  .group('people.id')
                  .order(:full_name)

    nav_letters = []
    last_letter = ''

    # If the first letter of an author's name doesn't appear in the list of
    # letters, add it.
    authors.each do |author|
      if author.full_name[0] != last_letter
        last_letter = author.full_name[0]
        nav_letters << last_letter
      end
    end

    nav_letters

  end

  # Go to the first author whose last name starts with
  # first_letter
  def letter
    first_author = Person.where(topic_flag: true)
                       .where.not(full_name: [nil, '']) # filter out nils and blanks
                       .where("full_name LIKE ?", "#{params[:first_letter]}%")
                       .order(:full_name)
                       .first

    redirect_to(public_author_path(first_author))
  end

end
