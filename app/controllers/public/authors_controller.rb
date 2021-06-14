require "alphabetical_paginate"

class Public::AuthorsController < ApplicationController
  include Public::ControllersHelper

  layout "public"

  before_action :authenticate_user!

  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)
    @is_greek_letter = ('Α'..'Ω').include?(@letter)

    @alpha_params_options = {
        bootstrap3: true,
        include_all: false,
        js: false
    }

    topic_authors = Person.where(topic_flag: true).where.not(full_name: [nil, ''])

    @navigation_list = NavigationList.new(topic_authors, :full_name, 'A')

    greek_topic_authors = Person.where(topic_flag: true).where.not(greek_full_name: [nil, ''])
    @greek_navigation_list = NavigationList.new(greek_topic_authors, :greek_full_name, 'Α')

    if @is_greek_letter
      @authors = topic_authors.where("greek_full_name LIKE ?", "#{@letter}%")
                     .order(:greek_full_name)
      @is_greek_letter = true
    else
      @authors = topic_authors.where("full_name LIKE ?", "#{@letter}%")
                     .order(:full_name)
      @is_greek_letter = false
    end
  end

  def show
    @results_formatter = BriefResultFormatter.new([], [], [])
    @author = Person.find(params[:id])

    @translations_book = @author.texts
                             .where('text_type = ?', 'translation_book')
                             .order(:sort_census_id)

    @translations_part = @author.texts
                             .where('text_type = ?', 'translation_part')
                             .order(:sort_census_id)

    @studies_book = @author.texts
                        .where('text_type = ?', 'study_book')
                        .order(:sort_census_id)

    @studies_part = @author.texts
                        .where('text_type = ?', 'study_part')
                        .order(:sort_census_id)


    # Determine which list to show as active by deault.
    @active_list = :profile
    if !@translations_book.empty?
      @active_list = :translations_book
    elsif !@translations_part.empty?
      @active_list = :translations_part
    elsif !@studies_book.empty?
      @active_list = :studies_book
    elsif !@studies_part.empty?
      @active_list = :studies_part
    end

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
