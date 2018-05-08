class Person < ApplicationRecord
  has_many :components, through: :component_citations

  has_many :texts, foreign_key: 'topic_author_id'

  paginates_per 60

  has_paper_trail

  default_scope {order('last_name ASC, first_name ASC')}

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
    texts.sort_by {|text| text.sort_title.downcase}.each do |text|
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
    text_components.sort_by {|component| component.sort_title}.each do |component|
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
      @translation_countries = get_text_countries translations
    end
    @translation_countries
  end

  def get_text_countries(texts)
    countries = {}
    texts.each do |text|
      text.places.each do |place|
        if place.country
          if countries[place.country.al3_code]
            countries[place.country.al3_code] = countries[place.country.al3_code] + 1
          else
            countries[place.country.al3_code] = 1
          end
        end
      end
    end
    countries
  end
end
