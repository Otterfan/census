class Component < ApplicationRecord
  belongs_to :text
  has_many :component_citations
  accepts_nested_attributes_for :component_citations,  reject_if: :all_blank, :allow_destroy => true

  after_save {
    puts "Component record '#{self.id}' was updated. Will now update related Text record: [#{self.text.id}]"
  }

  def translators
    unless @translators
      load_citations_by_role
    end
    @translators
  end

  def load_citations_by_role
    @translators = []
    component_citations.each do |citation|
      if citation.role == 'translator'
        @translators << "<a href=\"\">#{citation.name}</a>".html_safe
      end
    end
  end

  def sort_title
    unless title
      return ''
    end
    title.gsub(/["'“”‘’«»:_.\[\]\*]/, '').sub(/^(An? )|(The )/,'').strip
  end

  def collection_clean
    unless collection
      return ''
    end
    collection.gsub(/["'“”‘’«»:_.\[\]\*]/, "").sub(/^(An? )|(The )/,'').strip
  end

  default_scope { order("ordinal ASC") }
end
