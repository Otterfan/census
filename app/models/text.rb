require 'elasticsearch/model'
require 'htmlentities'

class Text < ApplicationRecord
  include SharedMethods
  include TextSortable
  include Searchable

  belongs_to :language, optional: true
  belongs_to :topic_author, class_name: 'Person', optional: true
  belongs_to :status, optional: true
  belongs_to :volume, optional: true
  belongs_to :section, optional: true
  belongs_to :journal, optional: true
  has_many :text_citations, inverse_of: :text, :dependent => :delete_all
  has_many :standard_numbers, inverse_of: :text, :dependent => :delete_all
  has_many :components, inverse_of: :text, :dependent => :delete_all
  has_many :comments, inverse_of: :text, :dependent => :delete_all
  has_many :cross_references, inverse_of: :text, :dependent => :delete_all

  has_many :other_text_languages, inverse_of: :text, :dependent => :delete_all
  has_many :languages, :through => :other_text_languages, :class_name => 'Language'

  has_many :publication_places, inverse_of: :text, :dependent => :delete_all
  has_many :places, :through => :publication_places, :class_name => 'Place'

  has_many :urls, inverse_of: :text, :dependent => :delete_all

  accepts_nested_attributes_for :text_citations, :standard_numbers, :components, :urls, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :other_text_languages, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :publication_places, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :cross_references, reject_if: :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :components, reject_if: :all_blank, :allow_destroy => true

  before_save :default_values

  after_touch {
    puts "Text record '#{self.id}' was touched."
    #__elasticsearch__.index_document
  }

  after_commit {
    puts "Text record '#{self.id}' was updated. Will now reindex."
    __elasticsearch__.index_document
  }

  paginates_per 60

  has_paper_trail

  def next
    if sort_census_id.empty?
      Text.where(["id > ?", id]).order(id: :asc).first
    else
      Text.where(["sort_census_id > ?", sort_census_id]).order(sort_census_id: :asc).first
    end
  end

  def previous
    if sort_census_id.empty?
      Text.where(["id < ?", id]).order(id: :desc).first
    else
      Text.where(["sort_census_id < ?", sort_census_id]).order(sort_census_id: :desc).first
    end
  end

  def authors
    unless @authors
      get_contributors
    end

    if text_type.respond_to?(:starts_with?) && text_type.starts_with?('translat')
      author_citation = TextCitation.new
      author_citation.name = topic_author.full_name
      @authors = [author_citation]
    end

    @authors
  end

  def authors_names
    unless @authors
      get_contributors
    end

    authors_names = @authors.map.map(&:name)
    translators_names = @translators.map { |person| person.name + ' (tr.)' }
    named_contributors = authors_names + translators_names
    named_contributors.join('; ')
  end

  def translators
    unless @translators
      get_contributors
    end
    @translators
  end

  def translators_names
    self.translators.map { |person| person.name.strip }
  end

  def editors
    unless @editors
      get_contributors
    end
    @editors
  end

  def editors_names
    self.editors.map { |person| person.name.strip }
  end

  def other_contributors
    unless @other_contributors
      get_contributors
    end
    @other_contributors
  end

  def get_contributors
    @authors, @translators, @editors, @other_contributors = [], [], [], []
    text_citations.each do |citation|
      if citation.role == 'translator'
        @translators << citation
      elsif citation.role == 'author'
        @authors << citation
      elsif citation.role == 'editor'
        @editors << citation
      else
        @other_contributors << citation
      end
    end
  end

  def poems
    unless @poems
      get_components
    end
    puts @poems
    @poems
  end

  def stories
    unless @stories
      get_components
    end
    @stories
  end

  def isbns
    @isbns ||= standard_numbers.select { |n| n.numtype = 'ISBN' }
  end

  def other_components
    unless @other_components
      get_components
    end
    @other_components
  end

  def get_components
    @poems, @stories, @other_components = [], [], []
    components.each do |component|
      if component.genre == 'Poetry'
        @poems << component
      elsif component.genre == 'Short story'
        @stories << component
      else
        @other_components << component
      end
    end
  end

  def formatted_original
    if original.include? '<p>'
      markdown
    end
  end

  def original_clean
    if original
      # duplicate the original field for our transformations
      @cleaned_original = original.dup

      # apply clean_field method
      clean_field @cleaned_original
    else
      nil
    end
  end

  def collection_clean
    if collection
      # duplicate the original field for our transformations
      @cleaned_collection = collection.dup

      # apply clean_field method
      clean_field @cleaned_collection
    else
      nil
    end
  end

  def editorial_annotation_clean
    if editorial_annotation
      # duplicate the original field for our transformations
      @cleaned_editorial_annotation = editorial_annotation.dup

      # apply clean_field method
      clean_field @cleaned_editorial_annotation
    else
      nil
    end
  end

  def abstract_clean
    if abstract
      # duplicate the original field for our transformations
      @cleaned_abstract = abstract.dup

      # apply clean_field method
      clean_field @cleaned_abstract
    else
      nil
    end
  end

  def physical_description_clean
    if physical_description
      # duplicate the original field for our transformations
      @cleaned_physical_description = physical_description.dup

      # apply clean_field method
      clean_field @cleaned_physical_description
    else
      nil
    end
  end

  def note_clean
    if note
      # duplicate the original field for our transformations
      @cleaned_note = note.dup

      # apply clean_field method
      clean_field @cleaned_note
    else
      nil
    end
  end

  def original_collections
    unless @original_collections
      @original_collections = []

      components.each do |component|
        next if component.collection.blank?
        next if @original_collections.include?(component.collection)

        title = component.collection.gsub(/^[Ff]rom /, '')
        title = title.gsub(/[^a-z0-9\s]/i, '')

        @original_collections << title
      end
    end

    @original_collections
  end

  def original_source
    @original_collections + [original_greek_collection, original_greek_title]
  end

  # Pull out all unique and non-empty values for a column.
  # Only useful for fields containing a controlled vocab
  def self.get_unique_values(field_name)
    puts "running search on field: " + field_name
    Text.where.not(field_name => [nil, ""]).order(field_name => :asc).pluck(field_name).uniq
  end

  # Default values for blank fields
  def default_values

    # Set publication place to journal pub place if blank
    if self.publication_places.empty? && self.journal && self.journal.place
      pub_place = PublicationPlace.new
      pub_place.place = self.journal.place
      pub_place.text = self
      self.publication_places << pub_place
    end
  end

  def original_greek_citation
    citation = nil

    has_title = !original_greek_title.nil? && !original_greek_title.empty?
    has_publisher = !original_greek_publisher.nil? && !original_greek_publisher.empty?
    has_date = !original_greek_date.nil? && !original_greek_date.empty?
    has_place = !original_greek_place_of_publication.nil? && !original_greek_place_of_publication.empty?

    if has_title && has_publisher && has_place && has_date
      citation = "#{original_greek_title} (#{original_greek_place_of_publication}: #{original_greek_publisher}, #{original_greek_date})"
    elsif has_title && has_publisher && has_date
      citation = "#{original_greek_title} (#{original_greek_publisher}, #{original_greek_date})"
    elsif has_title && has_publisher
      citation = "#{original_greek_title} (#{original_greek_publisher})"
    elsif has_title && has_date
      citation = "#{original_greek_title} (#{original_greek_date})"
    elsif has_title && has_place
      citation = "#{original_greek_title} (#{original_greek_place_of_publication})"
    elsif has_title
      citation = original_greek_title
    end

    citation
  end

  def display_text_type
    if text_type === 'translation_part'
      'Translation (item)'
    elsif text_type === 'translation_book'
      'Translation (volume)'
    elsif text_type === 'study_part'
      'Study (item)'
    else
      'Study (volume)'
    end
  end

  def plural_display_text_type
    if text_type === 'translation_part'
      'Translations (part)'
    elsif text_type === 'translation_book'
      'Translations (volume)'
    elsif text_type === 'study_part'
      'Studies (part)'
    else
      'Studies (volume)'
    end
  end

  def display_page_span
    return nil if page_span.empty?

    if page_span.include?('p.')
      return page_span
    end
    page_mark = page_span.include?('-') || page_span.include?(',') ? 'pp' : 'p'
    page_mark + '. ' + page_span
  end

  def searchable_is_special_issue
    is_special_issue ? 'special issue' : ''
  end

  def searchable_is_collected_volume
    is_collected_volume ? 'collected volume' : ''
  end

  def available_online
    urls.any? { |u| u.value.include?('http') } ? 'available online' : ''
  end

  def is_translation
    text_type.respond_to?(:starts_with?) && text_type.starts_with?('translat')
  end

  def publication_countries
    country_list = CountryList.new
    places.each do |place|
      if place.country
        country_list.add_country(place.country)
      end
    end
    country_list.names
  end

  # Returns a message if the Census ID is invalid
  def census_id_evaluation
    if /\A\d\./.match(census_id).nil?
      "Census ID must start with a digit"
    end
  end

  def issue_identifier
    if issue_number && issue_season_month
      return "#{issue_number} #{issue_season_month}"
    elsif issue_number
      return issue_number
    elsif issue_season_month
      return issue_season_month
    end

    nil
  end

end

#Text.import(force: true) # for auto sync model with elastic search
