require "alphabetical_paginate"

class AuthorsController < ApplicationController
  include ControllersHelper

  layout "public"

  STUDY_SORT_FIELDS = { sort_author: :asc, sort_title: :asc, sort_date: :asc }
  TRANSLATION_SORT_FIELDS = { sort_title: :asc, sort_translator: :asc, sort_date: :asc }

  def index
    default_letter = "A"
    @letter = sanitize_letter(params[:letter], default_letter)
    @is_greek_letter = ('Α'..'Ω').include?(@letter)

    @alpha_params_options = {
      bootstrap3: true,
      include_all: false,
      js: false
    }

    topic_authors = Person.where(topic_flag: true).where.not(full_name: [nil, '']).order(:first_name)
    @navigation_list = NavigationList.new(topic_authors, :full_name, 'A')

    greek_topic_authors = Person.where(topic_flag: true).where.not(greek_full_name: [nil, ''])
    @greek_navigation_list = NavigationList.new(greek_topic_authors, :greek_full_name, 'Α')

    if @is_greek_letter
      @authors = Person.where(topic_flag: true).where.not(full_name: [nil, '']).where("greek_full_name LIKE ?", "#{@letter}%")
                       .unscope(:order)
                       .order(:greek_full_name)
      @is_greek_letter = true
    else
      @authors = topic_authors.where("full_name LIKE ?", "#{@letter}%")
                              .unscope(:order)
                              .order(:sort_full_name)
      @is_greek_letter = false
    end
  end

  def show_by_type

    # Build text type, e.g. "study_book", "translation_items"
    type = params[:genre] == 'studies' ? 'study' : 'translation'
    type = params[:medium] == 'items' ? "#{type}_part" : "#{type}_book"

    # Studies sort by author, translations by title.
    sort_option = params[:genre] == 'studies' ? STUDY_SORT_FIELDS : TRANSLATION_SORT_FIELDS

    @results_formatter = BriefResultFormatter.new([], [], [])
    @author = Person.find(params[:id])
    @texts = @author.texts
                    .where('text_type = ?', type)
                    .order(**sort_option)
    @current_page = type

    render 'authors/show'
  end

  def show
    types = %w[translation_book translation_part study_book study_part]

    has_examples = false
    idx = 0
    type = ''

    author = Person.find(params[:id])

    until has_examples
      type = types[idx]
      break unless type
      has_examples = author.has_texts_of_type?(type)
      idx = idx + 1
    end

    unless type.nil?
      genre = type.include?('study') ? 'studies' : 'translations'
      medium = type.include?('book') ? 'books' : 'items'
    else
      type = 'studies'
      medium = 'books'
    end

    redirect_to "/authors/#{params[:id]}/#{genre}/#{medium}"

  end

  def profile
    @author = Person.find(params[:id])
    @current_page = :profile
    render 'authors/show'
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

    redirect_to(author_path(first_author))
  end

end
