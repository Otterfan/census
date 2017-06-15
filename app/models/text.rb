class Text < ApplicationRecord
  belongs_to :language, optional: true
  belongs_to :topic_author, class_name: 'Person', optional: true
  belongs_to :status
  has_many :text_citations, inverse_of: :text

  accepts_nested_attributes_for :text_citations

  default_scope { order("id ASC") }
end
