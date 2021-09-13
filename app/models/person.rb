class Person < ApplicationRecord
  include SharedMethods
  include PersonSortable

  has_many :components, through: :component_citations

  has_many :texts, foreign_key: 'topic_author_id'

  belongs_to :see_person, :class_name => "Person", :foreign_key => "see_person_id", optional: true

  paginates_per 60

  has_paper_trail

  default_scope { order('last_name ASC, first_name ASC') }

  auto_strip_attributes :last_name, :first_name, squish: true
  auto_strip_attributes :full_name, squish: true
  auto_strip_attributes :greek_full_name, squish: true
  auto_strip_attributes :greek_last_name, squish: true
  auto_strip_attributes :greek_first_name, squish: true


=begin
  after_commit {
    puts "Person record '#{self.id}' was updated. Will now touch related Text record(s)"
    self.texts.each(&:touch)
  }
=end

  def translations
    unless @translations
      get_texts_by_type
    end
    @translations
  end

  def studies
    unless @studies
      get_texts_by_type
    end
    @studies
  end

  def poems
    unless @poems
      get_text_components_by_type
    end
    @poems
  end

  def stories
    unless @stories
      get_text_components_by_type
    end
    @poems
  end

  def get_texts_by_type
    @translations, @studies = [], []
    texts.sort_by { |text| text.sort_title.downcase }.each do |text|
      if !text.text_type
      elsif text.text_type.start_with? 'trans'
        @translations << text
      else
        @studies << text
      end
    end
  end

  def get_text_components_by_type
    @poems, @stories = [], []
    text_components = Component.joins(:text).where('texts.topic_author_id' => id)
    text_components.sort_by { |component| component.sort_title }.each do |component|
      if !component.text_type
      elsif component.genre == 'Poetry'
        @poems << component.title
      elsif component.genre == 'Short story'
        @stories << component.title
      end
    end
    @poems.uniq!
    @stories.uniq!
  end


  def translations_years
    unless @translation_years
      @translation_years = get_text_years translations
    end
    @translation_years
  end

  def get_text_years(texts)
    years = []
    texts.each do |text|
      year = text.date.to_s[/(\d{4})/, 1]
      if year
        years << year
      end
    end
    years
  end

  def translation_countries
    unless @translation_countries
      @translation_countries = get_text_countries texts
    end
    @translation_countries
  end

  def get_text_countries(texts)
    countries = CountryList.new

    texts.each do |text|
      text.places.each do |place|
        if place.country
          countries.add_country(place.country)
        end
      end
    end

    countries
  end

  def alternate_name_list
    alternate_name.split"\n"
  end

  def alternate_name_clean
    if alternate_name
      # duplicate the original field for our transformations
      @cleaned_alternate_name = alternate_name.dup

      # apply clean_field method
      clean_field(@cleaned_alternate_name, true)
    else
      nil
    end
  end

  def names_in_source
    unless @names_in_source
      @names_in_source = []
      texts.each do |text|
        if text.authors_name_from_source && text.authors_name_from_source.count('a-zA-Z') > 0
          @names_in_source << normalize_name(text.authors_name_from_source)
        end
      end
      @names_in_source.sort!.uniq!
    end
    @names_in_source
  end

  def names_not_in_source
    alt_names = alternate_name.split("\r\n").collect(&:strip)
    alt_names - names_in_source
  end

  def has_texts_of_type?(type)
    count = texts.where('text_type = ?', type).count
    count > 0
  end

  def normalize_name(name)
    # Remove extraneous whitespace.
    name.strip!
    name.gsub!(/  +/, ' ')

    # Remove bracketed things like [sic]
    anything_in_brackets = /\[[^\]]*\]/
    name.gsub!(anything_in_brackets, '')

    # Make sure single letters have periods.
    middle_initial_missing_a_period = /([ .][B-Z]) /
    starting_initial_missing_a_period = /^([B-Z] )/
    ending_initial_missing_a_period = /([B-Z])$/
    name.gsub!(starting_initial_missing_a_period, '\1.')
    name.gsub!(ending_initial_missing_a_period, '\1.')
    name.gsub!(middle_initial_missing_a_period, '\1.')

    name
  end

end
