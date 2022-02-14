class Component < ApplicationRecord
  include SharedMethods

  belongs_to :text
  has_many :component_citations
  accepts_nested_attributes_for :component_citations, reject_if: :all_blank, :allow_destroy => true

  after_commit {
    puts "Component record '#{self.id}' was updated. Will now update related Text record: [#{self.text.id}]"
  }

  def translators
    unless @translators
      load_citations_by_role
    end
    @translators
  end

  def authors
    unless @authors
      load_citations_by_role
    end
    @authors
  end

  def load_citations_by_role
    @translators = []
    @authors = []
    component_citations.each do |citation|
      if citation.role == 'translator'
        @translators << citation
      elsif citation.role.include? 'author'
        @authors << citation
      end
    end
  end

  # Pull out all unique and non-empty values for a column.
  # Only useful for fields containing a controlled vocab
  def self.get_unique_values(field_name)
    puts "running search on field: " + field_name
    Component.where.not(field_name => [nil, ""]).order(field_name => :asc).pluck(field_name).uniq
  end

  def sort_title
    unless title
      return ''
    end
    title.gsub(/["'“”‘’«»:_.\[\]\*]/, '').sub(/^(An? )|(The )/, '').strip
  end

  def collection_clean
    unless collection
      return ''
    end
    collection.gsub(/["'“”‘’«»:_.\[\]\*]/, "").sub(/^(An? )|(The )/, '').strip
  end

  def greek_source_title_clean
    greek_source_title ? clean_field(greek_source_title) : nil
  end

  def greek_collection_title_clean
    greek_collection_title ? clean_field(greek_collection_title) : nil
  end

  default_scope {order("ordinal ASC")}
end
